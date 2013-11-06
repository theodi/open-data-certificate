//= require surveyor/jquery-ui-1.10.0.custom
//= require surveyor/jquery-ui-timepicker-addon
//= require surveyor/jquery.selectToUISlider
//X require surveyor/jquery.maskedinput

/*jshint quotmark: false */
/*global $, _ */

// Javascript UI for surveyor
$(document).ready(function($){

  'use strict';

  // A reimplementation of slideToggle which accepts a boolean parameter
  $.fn.slide = function(state) {
    return this.animate({height: state ? 'show' : 'hide'});
  };

  // A toggle class which tracks an integer value
  // Allows a loading icon to be toggled by multiple events
  $.fn.countToggleClass = function(className, increment) {
    var key = 'count-toggle-'+className;
    this.data(key, (this.data(key) || 0) + (increment || 1));
    return this.toggleClass(className, this.data(key) > 0);
  };

  _.templateSettings = {
    interpolate: /:(\w+)/g
  };

  // Default Datepicker uses jQuery UI Datepicker
  $('input[type="text"].datetime').datetimepicker({
    showSecond: true,
    showMillisec: false,
    timeFormat: 'HH:mm:ss',
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });

  $('li.date input, input[type="text"].date, input[type="text"].datepicker').datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });

  $('input[type="text"].time').timepicker({});

  $('.surveyor_check_boxes input[type=text]').change(function(){
    var textValue = $(this).val();
    if (textValue.length > 0) {
      $(this).parent().children().has('input[type="checkbox"]')[0].children[0].checked = true;
    }
  });

  $('.surveyor_radio input[type=text]').change(function() {
    if ($(this).val().length > 0) {
      $(this).parent().children().has('input[type="radio"]')[0].children[0].checked = true;
    }
  });

  // http://www.filamentgroup.com/lab/update_jquery_ui_slider_from_a_select_element_now_with_aria_support/
  $('fieldset.q_slider select').each(function(i,e) {
    $(e).selectToUISlider({"labelSrc": "text"}).hide();
  });

  // If javascript works, we don't need to show dependents from
  // previous sections at the top of the page.
  $("#dependents").remove();

  function successfulSave(responseText) {
    // surveyor_controller returns a json object to show/hide elements
    // e.g. {"hide":["question_12","question_13"],"show":["question_14"]}
    $.each(responseText.show, function(key, id) { $('#'+id).removeClass("g_hidden q_hidden"); });
    $.each(responseText.hide, function(key, id) { $('#'+id).addClass("g_hidden q_hidden"); });

    $(document).trigger('surveyor-update', responseText);
    return false;
  }

  // is_exclusive checkboxes should disble sibling checkboxes
  $('input.exclusive:checked').parents('fieldset[id^="q_"]').
    find(':checkbox').
    not(".exclusive").
    attr('checked', false).
    attr('disabled', true);

  $('input.exclusive:checkbox').click(function(){
    var e = $(this);
    var others = e.parents('fieldset[id^="q_"]').find(':checkbox').not(e);
    if(e.is(':checked')){
      others.attr('checked', false).attr('disabled', 'disabled');
    }else{
      others.attr('disabled', false);
    }
  });

  // we don't use the input mask anymore because of problems with
  // IE, if it ever does get used, notify us through airbrake.
  $("input[data-input-mask]").each(function(i,e){
    var message = "input mask not supported on certificates";
    if(window.Airbrake){
      window.Airbrake.notify({
        message: message,
        stack: '()@surveyor_all.js:0'
      });
    } else {
      console.error(message);
    }
    // var inputMask = $(e).attr('data-input-mask');
    // var placeholder = $(e).attr('data-input-mask-placeholder');
    // var options = { placeholder: placeholder };
    // $(e).mask(inputMask, options);
  });

  // translations selection
  $(".surveyor_language_selection").show();
  $(".surveyor_language_selection select#locale").change(function(){ this.form.submit(); });

  var $form = $("#survey_form");
  var $surveyor = $form.find('#surveyor');
  var csrfToken = $form.find("input[name='authenticity_token']");

  var busy = false;
  var template = _.template("repeater_field/:question_id/:response_index/:response_group");

  $form.on('click', '.add_row', function() {
    if (busy) return;
    busy = true;

    var $button = $(this);
    var $row = $button.closest('.g_repeater');

    var responseIndexes = $form.find('input[name^=r\\[]').toArray().map(function(elem) {
      return parseInt(elem.name.match(/^r\[(\d+)\]/)[1] || 0, 10);
    });

    var url = template({
      question_id: $row.find('input[name*=question_id]').val(),
      response_index: Math.max.apply(this, responseIndexes) + 1,
      response_group: $row.find('.q_repeater_default').length
    });

    $.ajax(url).done(function(html) {
      $button.before(html);
      $row.find('.remove_row').toggleClass('hide', $row.find('.question').length == 1);
      busy = false;
    });

    return false;
  })
  .on('click', '.remove_row', function() {
    var $button = $(this).attr('disabled',true);
    var $row = $button.closest('.g_repeater');
    var $question = $button.closest('.question');

    $question.find('input.string').val('');
    $question.insertBefore($row.find('.add_row')).hide();
    $row.find('input[name$="[response_group]"]').each(function(i){ $(this).val(i); });

    saveFormElements($form, $row.find('input').add(csrfToken));
    $question.remove();
    $row.find('.remove_row').toggleClass('hide', $row.find('.question').length == 1);

    return false;
  });


  function updateField($field) {
    var $row = bindQuestionRow($field);

    $row.countToggleClass('loading', 1);
    saveFormElements($form, questionFields($field).add(csrfToken), function() {
      $row.countToggleClass('loading', -1);
    });
    validateField($field);
  }

  // Update radio, checkbox and select form fields on click
  $form.on("change paste", "input, select, textarea", function() {
    var $field = $(this);
    var $row = bindQuestionRow($field);

    clearTimeout($row.data('update-timeout'));
    updateField($field);
  });

  // Updates text form after users finish typing
  $form.on("keyup", "input[type=text], input[type=url], input[type=email], textarea", function() {
    var $field = $(this);
    var $row = bindQuestionRow($field);

    clearTimeout($row.data('update-timeout'));
    $row.data('update-timeout', setTimeout(function() {
      updateField($field);
    }, 700));
  });

  function changeState($row, state) {
    $row.removeClass('no-response ok warning').addClass(state);
  }

  var validations = {
    documentationUrl: function($row) { return $row.data('reference-identifier') == 'documentationUrl'; },
    url: function($row, $field) { return $field.attr('type') == 'url'; },
    metadata: function($row) { return $row.data('metadata-field') && $row.data('autocompletable'); },
    other: function() { return true; }
  };

  var actions = {
    documentationUrl: function($row, $field, callback) {
      var url = $field.val();
      if (empty(url)) return callback(true);
      if (!validateUrl(url)) return callback(false);

      var id = $surveyor.data('response-id');
      $.post('/surveys/response_sets/'+id+'/autofill', {url: url, dataType: 'json'})
        .done(function(json) {

          // Mark questions which have selected radio buttons or checkboxes
          $form.find('fieldset.question-row').each(function() {
            var $row = $(this);
            $row.toggleClass('touched', $row.find('input:checked').filter('[type=radio], [type=checkbox]').length > 0);
          });

          // Fill in fields
          var affectedFields = [];
          if (json.data_exists) {
            var field;
            for (field in json.data) {
              affectedFields.push(fillField(field, json.data[field]));
            }
          }
          callback(json.status == 200, {fields: toJquery(affectedFields)});
        })
        .error(function() { callback(false); });
    },
    url: function($row, $field, callback) {
      var url = $field.val();
      if (empty(url)) return callback(true);
      if (!validateUrl(url)) return callback(false);

      var id = $surveyor.data('response-id');
      $.post('/surveys/response_sets/'+id+'/resolve', {url: url, dataType: 'json'}).done(function(json) {
        callback(json.status == 200);
      });
    },
    metadata: function($row, $field, callback) {
      var question = $row.data('reference-identifier');
      var autoValue = $row.data('autocompleted-value').toString();
      var autoValues = autoValue.split(',').map(function(value) {
        return answerIdentifier(question, value);
      }).sort();

      var selectedValues = $row.find('li:has(input:checked)').map(function() {
        return $(this).data('reference-identifier');
      }).get().sort();

      var missingValues = selectedValues.filter(function(value) {
        return autoValues.indexOf(value) === -1;
      });

      callback(missingValues.length === 0, {missingValues: missingValues});
    },
    other: function($row, $field, callback) { callback(true); }
  };

  var responses = {
    documentationUrl: function($row, $field, success, data) {
      if (success) {
        data.fields.each(function() { validateField($(this)); });
        saveFormElements($form, questionFields(data.fields).add(csrfToken));
        $('#status_panel').trigger('update');
      }
      responses.url($row, $field, success);
    },
    url: function($row, $field, success) {
      $row.data('url-verified', success);
      if (!success) {
        $row.find('.status-message span').text($surveyor.data('url-incorrect'));
      }
    },
    metadata: function($row, $field, success, data) {
      $row.find('.surveyor_check_boxes').removeClass('warning');
      $row.data('metadata-missing', !success);

      if (!success) {
        var $answers = $row.find('.surveyor_check_boxes').removeClass('warning');
        data.missingValues.each(function(value) {
          $answers.filter('[data-reference-identifier="'+ value +'"]').addClass('warning');
        });
      }
    }
  };

  function validateField($field) {
    var $row = bindQuestionRow($field);

    var matched = false;
    ['documentationUrl', 'url', 'metadata', 'other'].each(function(name) {
      if (!matched && validations[name]($row, $field)) {
        matched = true;

        $row.countToggleClass('loading', 1);

        if ($row.data('validate-callback')) $row.data('validate-callback').cancelled = true;
        var status = {cancelled: false};
        $row.data('validate-callback', status);

        var callback = function(success, $data) {
          $row.countToggleClass('loading', -1);
          if (status.cancelled) return;

          changeState($row, success ? 'ok' : 'warning');

          if (responses[name]) {
            responses[name]($row, $field, success, $data || {});
          }

          // If the field can be autocompleted
          if ($row.data('autocompletable')) {
            markAutocompleted($row, checkAutocompleted($row));
          }
          // Otherwise remove all state if the field is empty
          else if (empty($field.val())) {
            changeState($row, 'no-response');
          }

          updateExplanation($row, empty($field.val()));
        };

        actions[name]($row, $field, callback);
      }
    });
  }

  function bindQuestionRow($field) {
    var $row = $field.data('question-row') || $field.closest('.question-row');
    $field.data('question-row', $row);
    return $row;
  }

  function validateUrl(url) {
    return url.match(/^(https?:\/\/)[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?/i);
  }

  function questionFields($field) {
    return $field.closest('fieldset.question-row').find("input, select, textarea");
  }

  function answerIdentifier($question, $answer) {
    return $question + '_' + $answer;
  }

  function checkAutocompleted($row) {
    if (!$row.data('autocompletable')) return false;

    var autoValue = $row.data('autocompleted-value').toString();

    var $inputs = $row.find('li.input');
    var question = $row.data('reference-identifier');


    if ($inputs.hasClass('string')) {
      return autoValue == $row.find('input.string').val();
    }

    if ($inputs.hasClass('select')) {
      var identifier = $row.find('option:selected').data('reference-identifier');
      return answerIdentifier($row.data('reference-identifier'), autoValue) == identifier;
    }

    if ($inputs.hasClass('surveyor_check_boxes') || $inputs.hasClass('surveyor_radio')) {
      var autoValues = autoValue.split(',').map(function(value) {
        return answerIdentifier(question, value);
      }).sort();

      var selectedValues = $row.find('li:has(input:checked)').map(function() {
        return $(this).data('reference-identifier');
      }).get().sort();

      if (selectedValues.length != autoValues.length) return false;

      return autoValues.filter(function(value, i) { return value != selectedValues[i]; }).length === 0;
    }
  }

  function markAutocompleted($row, autocompleted) {
    if (!$row.data('autocompletable')) return;

    $row.find('input[id$="_autocompleted"]').val(autocompleted);
    $row.toggleClass('autocompleted', autocompleted);
    $row.data('autocompleted', autocompleted);

    var message = autocompleted ? 'autocompleted' : 'autocomplete-override-warning';
    if ($row.data('metadata-missing')) message = 'missing-metadata';
    if ($row.data('url-verified') === false && autocompleted) message = 'autocompleted-url-incorrect';
    $row.find('.status-message span').text($surveyor.data(message));
  }

  function updateExplanation($row, fieldEmpty) {
    var explanationEmpty = empty($row.find('.autocomplete-override textarea').val());

    var message = '';
    if ($row.data('url-verified') === false) {
      message = $surveyor.data('url-explanation');
    }
    if ($row.data('autocompleted') === false) {
      message = $surveyor.data('autocomplete-explanation');
    }

    var override = $row.find('.autocomplete-override');
    if (message) override.find('p').text(message);
    override.slide(message);

    if (!$row.data('metadata-missing') && !fieldEmpty) {
      changeState($row, message && explanationEmpty ? 'warning' : 'ok');
    }
  }

  function saveFormElements($form, $elements, callback) {
    $.ajax({
      type: "PUT",
      url: $form.attr("action"),
      data: $elements.serialize(), dataType: 'json',
      success: function(response) {
        successfulSave(response);
        if (callback) callback();
      },
      error: function(){
        // This throws on aborted requests (so when the save button is clicked and page unloaded while it is being sent)
        // would be good to have this in still, though to stop the alert when you save (and it has saved), removing for now
        //alert("an error occured when saving your response");
      }
    });
  }

  // Collects a sparse array of jQuery objects into a single jQuery object
  function toJquery(array) {
    return $(array.filter(function(field) { return field; })).map(function() { return this.toArray(); });
  }

  // Checks if a string is empty (blank or whitespace only)
  function empty(text) {
    return !text || text.match(/^[\s]*$/);
  }

  function fillField(question, answer) {
    var $row = $('fieldset[data-reference-identifier="'+ question +'"]');
    $row.data('autocompleted-value', $.isArray(answer) ? answer.join(',') : answer);
    $row.data('autocompletable', true);
    var $input = $row.find('li.input');

    if ($input.hasClass('string')) {
      return fillMe($row, question, answer);
    }

    if ($input.hasClass('select')) {
      return selectMe($row, question, answer);
    }

    if ($input.hasClass('surveyor_check_boxes') || $input.hasClass('surveyor_radio')) {
      if ($.isArray(answer)) {
        return toJquery(answer.map(function(option) { return checkMe($row, question, option); }));
      }

      return checkMe($row, question, answer);
    }
  }

  // Utility function to select nth option
  function selectMe($row, question, answer) {
    var $field = $row.find('select');
    if ($field.val()) return;
    return $field.children('option[data-reference-identifier="'+ answerIdentifier(question,answer) +'"]').prop('selected', true);
  }

  // Utility function to populate input fields by identifier
  function fillMe($row, question, value) {
    var $field = $row.find('input.string');
    if (!empty($field.val()) || empty(value)) return;
    return $field.val(value);
  }

  // Utility function to check input fields by identifier
  function checkMe($row, question, answer) {
    if ($row.hasClass('touched')) return;
    return $row.find('li[data-reference-identifier="'+ answerIdentifier(question,answer) +'"] input').prop('checked', true);
  }
});
