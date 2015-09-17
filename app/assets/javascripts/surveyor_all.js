//= require surveyor/jquery-ui-1.10.0.custom
//= require surveyor/jquery-ui-timepicker-addon
//= require surveyor/jquery.selectToUISlider
//X require surveyor/jquery.maskedinput

/*jshint quotmark: false */
/*global $ */

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

  // Tracks whether the form is currently saving
  var updateLoading = (function() {
    var $saveButton = $(".save-button");
    var $input = $saveButton.find('.btn');
    var $text = $input.find('span');
    var count = 0;

    $input.data('btn-default', $text.text());

    var update = function(i) {
      count = count + i;
      $saveButton.toggleClass('loading', count > 0);
      $input.toggleClass('btn-confirmed disabled', count > 0);
     $text.text(count > 0 ? $input.data('btn-loading') : $input.data('btn-default'));
    }

    $input.click(function() { update(1); });

    return update;
  })();

  var busy = false;
  var template = Hogan.compile("repeater_field/{{question_id}}/{{response_index}}/{{response_group}}");

  $form.on('click', '.add_row', function() {
    if (busy) return;
    busy = true;

    var $button = $(this);
    var $row = $button.closest('.g_repeater');

    var responseIndexes = $form.find('input[name^=r\\[]').toArray().map(function(elem) {
      return parseInt(elem.name.match(/^r\[(\d+)\]/)[1] || 0, 10);
    });

    var url = template.render({
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


  function updateField($row) {
    var $field = $row.find('input[type=text], input[type=url], input[type=email], input[type=checkbox], input[type=radio], select');

    saveFormElements($form, questionFields($field).add(csrfToken));

    $row.data('field', $field);
    $row.data('url-field', urlField($field));
    $row.data('autocompleted', checkAutocompleted($row));
    $row.data('explained', explanationGiven($row));
    $row.data('empty', fieldEmpty($field));

    updateCheckedFields($row);

    var missing = metadataMissing($row);
    updateMetadata($row, missing);
    $row.data('metadata-missing', missing && missing.length);

    if ($row.data('url-field')) {
      verifyUrl($row, function(verified) {
        $row.data('url-verified', verified);

        validateField($row);
      });
    }

    validateField($row);
  }

  // Finds the value from the row to check if the field has changed
  function rowValue($row) {
    var $input = $row.find('li.input');

    if ($input.hasClass('string')) {
      return $input.find('input.string').val();
    }

    if ($input.hasClass('select')) {
      return $input.find('select').val();
    }

    if ($input.hasClass('surveyor_check_boxes')) {
      return $input.find('input:checked').toArray().map(function(input) { return $(input).val(); }).join(',');
    }

    if ($input.hasClass('surveyor_radio')) {
      return $input.find('input:checked').val();
    }
  };

  // Sets initial form values
  $form.find('.question-row').each(function() {
    var $row = bindQuestionRow($(this));
    $row.data('value', rowValue($row));
  });

  // Updates radio, checkbox and select form fields on click
  $form.on("change paste", "input, select, textarea", function() {
    var $field = $(this);
    var $row = bindQuestionRow($field);

    var value = rowValue($row);
    if ($row.data('value') == value) return;
    $row.data('value', value);

    clearTimeout($row.data('update-timeout'));
    updateField($row);
  });

  // Updates text form after users finish typing
  $form.on("keyup", "input[type=text], input[type=url], input[type=email], textarea", function() {
    var $field = $(this);
    var $row = bindQuestionRow($field);

    var value = rowValue($row);
    if (!$field.is('textarea') && $row.data('value') == value) return;
    $row.data('value', value);

    clearTimeout($row.data('update-timeout'));
    $row.data('update-timeout', setTimeout(function() {
      updateField($row);
    }, 700));
  });

  var states = [
    'no-response',
    'ok',
    'error',
    'url-verified',
    'autocompleted',
    'autocompleted-changed',
    'autocompleted-explained',
    'url-warning',
    'autocompleted-url-warning',
    'url-explained',
    'metadata-missing'
  ];

  function changeState($row, state) {
    $row.removeClass(states.join(' ')).addClass(state);
    $row.find('.status-message span').text($surveyor.data(state));
  }

  function changeExplanation($row, explanation) {
    $row.find('.explanation .subtitle').text($surveyor.data(explanation));
  }

  function verifyUrl($row, next) {
    var url = $row.data('field').val();
    if ($row.data('empty')) return next(true);
    if (!validateUrl(url)) {
      if (!validateUrl('http://'+url)) {
        return next(false);
      }

      $row.data('field').val(url = 'http://'+url);
    }

    var id = $surveyor.data('response-id');
    $.post('/surveys/response_sets/'+id+'/resolve', {url: url, dataType: 'json'}).done(function(json) {
      next(json.valid);
    });
  }

  function urlField($field) {
    return $field.attr('type') == 'url';
  }

  function metadataMissing($row) {
    if (!$row.data('metadata-field') || !$row.data('autocompletable')) return false;

    var question = $row.data('reference-identifier');
    var autoValue = $row.data('autocompleted-value');
    var autoValues = (autoValue === null ? '' : autoValue.toString()).split(',').map(function(value) {
      return answerIdentifier(question, value);
    }).sort();

    var selectedValues = $row.find('li:has(input:checked)').map(function() {
      return $(this).data('reference-identifier');
    }).get().sort();

    return selectedValues.filter(function(value) {
      return autoValues.indexOf(value) === -1;
    });
  };

  function updateMetadata($row, missing) {
    if (!missing) return;

    var $answers = $row.find('.surveyor_check_boxes').removeClass('warning');
    missing.each(function(value) {
      $answers.filter('[data-reference-identifier="'+ value +'"]').addClass('warning');
    });
  }

  function updateCheckedFields($row) {
    $row.find('.surveyor_check_boxes, .surveyor_radio').each(function() {
      $(this).toggleClass('checked', $(this).find('[type=checkbox], [type=radio]').prop('checked'));
    })
  }

  function explanationGiven($row) {
    return !fieldEmpty($row.find('.explanation textarea'));
  };

  function validateField($row) {
    var $field = $row.data('field');

    var state = 'no-response';

    if (!$row.data('empty')) {
      state = 'ok';
    }

    if ($row.data('empty') && $row.data('mandatory')) {
      state = 'error';
    }

    if (!$row.data('empty') && $row.data('url-field')) {
      state = 'url-verified';
    }

    if ($row.data('autocompletable')) {
      changeExplanation($row, 'autocomplete-explanation');
      state = 'autocompleted';

      if (!$row.data('autocompleted')) {
        state = 'autocompleted-changed';

        if ($row.data('explained')) {
          state = 'autocompleted-explained';
        }
      }
    }

    if ($row.data('url-field') && !$row.data('url-verified')) {
      changeExplanation($row, 'url-explanation');
      state = 'url-warning';

      if ($row.data('autocompleted')) {
        state = 'autocompleted-url-warning';
      }

      if ($row.data('explained')) {
        state = 'url-explained';
      }
    }

    if ($row.data('metadata-missing')) {
      state = 'metadata-missing';

      if ($row.data('explained')) {
        state = 'autocompleted-explained';
      }
    }

    changeState($row, state);
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

  function saveFormElements($form, $elements) {
    updateLoading(1);
    $.ajax({
      type: "PUT",
      url: $form.attr("action"),
      data: $elements.serialize(), dataType: 'json'
    })
    .done(successfulSave)
    .always(function() {
      updateLoading(-1);
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

  function fieldEmpty($field) {
    return empty($field.val());
  }

  function fillField(question, answer) {
    var $row = $('fieldset[data-reference-identifier="'+ question +'"]');
    $row.data('autocompleted-value', $.isArray(answer) ? answer.join(',') : answer);
    $row.removeClass('q_hidden');
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
