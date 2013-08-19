//= require surveyor/jquery-ui-1.10.0.custom
//= require surveyor/jquery-ui-timepicker-addon
//= require surveyor/jquery.selectToUISlider
//= require surveyor/jquery.maskedinput

// Javascript UI for surveyor
$(document).ready(function(){
  // if(jQuery.browser.msie){
  //  // IE has trouble with the change event for form radio/checkbox elements - bind click instead
  //  jQuery("form#survey_form input[type=radio], form#survey_form [type=checkbox]").bind("click", function(){
  //    jQuery(this).parents("form").ajaxSubmit({dataType: 'json', success: successfulSave});
  //  });
  //  // IE fires the change event for all other (not radio/checkbox) elements of the form
  //  jQuery("form#survey_form *").not("input[type=radio], input[type=checkbox]").bind("change", function(){
  //    jQuery(this).parents("form").ajaxSubmit({dataType: 'json', success: successfulSave});
  //  });
  // }else{
  //  // Other browsers just use the change event on the form

  //
  // Uncomment the following to use the jQuery Tools Datepicker (http://jquerytools.org/demos/dateinput/index.html)
  // instead of the default jQuery UI Datepicker (http://jqueryui.com/demos/datepicker/)
  //
  // For a date input, i.e. using dateinput from jQuery tools, the value is not updated
  // before the onChange or change event is fired, so we hang this in before the update is
  // sent to the server and set the correct value from the dateinput object.
  // jQuery('li.date input').change(function(){
  //     if ( $(this).data('dateinput') ) {
  //         var date_obj = $(this).data('dateinput').getValue();
  //         this.value = date_obj.getFullYear() + "-" + (date_obj.getMonth()+1) + "-" +
  //             date_obj.getDate() + " 00:00:00 UTC";
  //     }
  // });
  //
  // $('li input.date').dateinput({
  //     format: 'dd mmm yyyy'
  // });

  // Default Datepicker uses jQuery UI Datepicker
  $("input[type='text'].datetime").datetimepicker({
    showSecond: true,
    showMillisec: false,
    timeFormat: 'HH:mm:ss',
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });

  $("li.date input, input[type='text'].date, input[type='text'].datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });

  $("input[type='text'].time").timepicker({});

  $('.surveyor_check_boxes input[type=text]').change(function(){
    var textValue = $(this).val()
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
    $(e).selectToUISlider({"labelSrc": "text"}).hide()
  });

  // If javascript works, we don't need to show dependents from
  // previous sections at the top of the page.
  $("#dependents").remove();

  function successfulSave(responseText) {
    // surveyor_controller returns a json object to show/hide elements
    // e.g. {"hide":["question_12","question_13"],"show":["question_14"]}
    $.each(responseText.show, function(){ showElement(this) });
    $.each(responseText.hide, function(){ hideElement(this) });

    $(document).trigger('surveyor-update', responseText);
    return false;
  }

  function showElement(id){
    group = id.match('^g_') ? true : false;
    if (group) {
      $('#' + id).removeClass("g_hidden");
    } else {
      $('#' + id).removeClass("q_hidden");
    }
  }

  function hideElement(id){
    group = id.match('^g_') ? true : false;
    if (group) {
      $('#' + id).addClass("g_hidden");
    } else {
      $('#' + id).addClass("q_hidden");
    }
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

  $("input[data-input-mask]").each(function(i,e){
    var inputMask = $(e).attr('data-input-mask');
    var placeholder = $(e).attr('data-input-mask-placeholder');
    var options = { placeholder: placeholder };
    $(e).mask(inputMask, options);
  });

  // translations selection
  $(".surveyor_language_selection").show();
  $(".surveyor_language_selection select#locale").change(function(){ this.form.submit(); });

  $("#survey_form").each(function() {
    var $form = $(this)
    var csrfToken = $form.find("input[name='authenticity_token']")

    $form.find("input, select, textarea").change(function() {
      var $field = $(this)

      // Set field to not autofilled
      markAutocompleted($field, $form, false)

      // Save changes to this field
      saveFormElements($form, questionFields($field).add(csrfToken), function() {
        validateField($field, $form, csrfToken)
      })
    })
  })

  function validateField($field, $form, csrfToken) {
    // Cache row element on field
    var $row = bindQuestionRow($field);

    // Cancel any ajax callbacks
    if ($field.data('cancel-callbacks')) $field.data('cancel-callbacks')()

    // Reset styles
    $row.removeClass('loading')
    $row.removeClass('error').removeClass('ok').removeClass('warning')

    if ($field.val() && $field.val().match(/[^\s]/)) {

      // Attempt to autocomplete fields
      if ($row.data('reference-identifier') == 'documentationUrl') {

        $row.addClass('loading')

        $field.data('cancel-callbacks', autocomplete($field.val(), {
          beforeProcessing: function() {
            // Mark questions which have selected radio buttons or checkboxes
            $form.find('fieldset.question-row').each(function() {
              var $row = $(this);
              $row.toggleClass('touched', $row.find('input:checked').filter('[type=radio], [type=checkbox]').length > 0)
            })
          },
          success: function($fields) {
            $row.addClass('ok')
            $row.removeClass('loading')

            // Mark fields as autcompleted
            markAutocompleted($fields, $form, true)

            // Run validation on each field
            $fields.each(function() { validateField($(this), $form, csrfToken) })

            // Save autocompleted fields
            saveFormElements($form, questionFields($fields).add(csrfToken))

            // Trigger status panel update
            $('#status_panel').trigger('update');
          },

          fail: function() {
            $row.addClass('warning')
            $row.removeClass('loading')

            var message = $row.hasClass('autocompleted') ? 'autocompleted-url-incorrect' : 'url-incorrect'
            $row.find('.status-message span').text($form.find('#surveyor').data(message))
          }
        }))
      }

      // Attempt to verify URL
      else if ($field.attr('type') == 'url') {

        $row.addClass('loading')

        $field.data('cancel-callbacks', verifyUrl($field.val(), {
          success: function() {
            $row.addClass('ok')
            $row.removeClass('loading')
          },

          fail: function() {
            $row.addClass('warning')
            $row.removeClass('loading')

            var message = $row.hasClass('autocompleted') ? 'autocompleted-url-incorrect' : 'url-incorrect'
            $row.find('.status-message span').text($form.find('#surveyor').data(message))
          }
        }))
      }

      // Approve regular field
      else {
        $row.addClass('ok')
      }
    }

    // Show errors for missing mandatory fields
    else if ($row.hasClass('mandatory')) {
      $row.addClass('error')
    }
  }

  function bindQuestionRow($field) {
    var $row = $field.data('question-row') || $field.closest('.question-row')
    $field.data('question-row', $row)
    return $row;
  }

  function verifyUrl(url, callbacks) {
    if (!validateUrl(url)) return callbacks.fail();

    $.getJSON('/resolve', { url: url } )
      .done(function(json) {
        if (json.status == 200) {
          callbacks.success()
        } else {
          callbacks.fail()
        }
      })

    // Function to clear callbacks if this request is superceeded
    return function() {
      callbacks.success = function() {}
      callbacks.fail = function() {}
    }
  }

  function validateUrl(url) {
    return url.match(/^(https?:\/\/)[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?/i)
  }

  function questionFields($field) {
    return $field.closest('fieldset.question-row').find("input, select, textarea");
  }

  function markAutocompleted($fields, $form, value) {
    // Toggle autocompleted field
    $fields.closest('fieldset.question-row').find('input[id$="_autocompleted"]').val(value);

    // Update autocompleted class on row
    $fields.each(function() {
      var $row = bindQuestionRow($(this))
      $row.toggleClass('autocompleted', value)

      // Set autocompleted message
      if (value) {
        $row.find('.status-message span').text($form.find('#surveyor').data('autocompleted'))
      }
    })
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

  // Checks if a string is empty (blank or whitespace only)
  function empty(text) {
    return !text || text.match(/^[\s]*$/)
  }

  // Utility function to select nth option
  function selectMe(question, answer) {
    var $field = $('fieldset[data-reference-identifier="'+ question +'"] select')
    if ($field.val()) return
    return $field.children('option[data-reference-identifier="'+ question+"_"+answer +'"]').prop('selected', true)
  }

  // Utility function to populate input fields by identifier
  function fillMe(identifier, val) {
    var $field = $('fieldset[data-reference-identifier="'+ identifier +'"]').find('input.string, select')
    if (!empty($field.val()) || empty(val)) return
    return $field.val(val)
  }

  // Utility function to check input fields by identifier
  function checkMe(question, answer) {
    var $row = $('fieldset[data-reference-identifier="'+ question +'"]')
    if ($row.hasClass('touched')) return
    return $row.find('li[data-reference-identifier="'+ question+"_"+answer +'"] input').prop('checked', true)
  }

  // Data Kitten autocompletion
  function autocomplete(url, callbacks) {
    if (!validateUrl(url)) return callbacks.fail();

    $.getJSON('/autofill', { url: url } )
      .error(callbacks.fail)
      .done(function(json) {

        callbacks.beforeProcessing();

        if (!json.data_exists) {
          return callbacks.success($([]));
        }

        var affectedFields = [];

        // Title
        affectedFields.push(fillMe("dataTitle", json.title))

        if (json.publishers.length > 0) {
          // Publisher name
          affectedFields.push(fillMe("publisher", json.publishers[0].name))
          // Publisher URL
          affectedFields.push(fillMe("publisherUrl", json.publishers[0].homepage))
          // Contact email address
          affectedFields.push(fillMe("contactEmail", json.publishers[0].mbox))
        }

        // Data type
        if (json.update_frequency.length == 0 && json.distributions.length == 1) {
          // One-off release of a single dataset
          affectedFields.push(checkMe("releaseType", "oneoff"))
        } else if (json.update_frequency.length == 0 && json.distributions.length > 1) {
          // One-off release of a set of related datasets
          affectedFields.push(checkMe("releaseType", "collection"))
        } else if (json.update_frequency.length > 0 && json.distributions.length > 1) {
          // Ongoing release
          affectedFields.push(checkMe("releaseType", "series"))
        }

        // A service or API for accessing open data
        if (json.title.indexOf("API") >= 0 || json.description.indexOf("API") >= 0 ) {
          affectedFields.push(checkMe("releaseType", "service"))
        }

        // Rights information
        if (json.rights) {
          // Yes, you have the rights to publish this data as open data
          affectedFields.push(checkMe("publisherRights", "yes"))
          // Rights statement
          affectedFields.push(fillMe("copyrightURL", json.rights.uri))

          // Data License
          switch(json.rights.dataLicense) {
            case "http://opendatacommons.org/licenses/by/":
              affectedFields.push(selectMe("dataLicence", "odc_by"))
              break;
            case "http://opendatacommons.org/licenses/odbl/":
              affectedFields.push(selectMe("dataLicence", "odc_odbl"))
              break;
            case "http://opendatacommons.org/licenses/pddl/":
              affectedFields.push(selectMe("dataLicence", "odc_pddl"))
              break;
            case "http://creativecommons.org/publicdomain/zero/1.0/":
              affectedFields.push(selectMe("dataLicence", "cc_zero"))
              break;
            case "http://reference.data.gov.uk/id/open-government-licence":
              affectedFields.push(selectMe("dataLicence", "uk_ogl"))
              break;
          }

          // Content License
          switch(json.rights.contentLicense) {
            case "http://creativecommons.org/licenses/by/2.0/uk/":
              affectedFields.push(selectMe("contentLicence", "cc_by"))
              break;
            case "http://creativecommons.org/licenses/by-sa/2.0/uk/":
              affectedFields.push(selectMe("contentLicence", "cc_by_sa"))
              break;
            case "http://creativecommons.org/publicdomain/zero/1.0/":
              affectedFields.push(selectMe("contentLicence", "cc_zero"))
              break;
            case "http://reference.data.gov.uk/id/open-government-licence":
              affectedFields.push(selectMe("contentLicence", "uk_ogl"))
              break;
          }
        } else if (json.licenses) {
          // Yes, you have the rights to publish this data as open data
          affectedFields.push(checkMe("publisherRights", "yes"))

          // Data License
          switch(json.licenses[0].uri) {
            case "http://opendatacommons.org/licenses/by/":
              affectedFields.push(selectMe("dataLicence", "odc_by"))
              break;
            case "http://opendatacommons.org/licenses/odbl/":
              affectedFields.push(selectMe("dataLicence", "odc_odbl"))
              break;
            case "http://opendatacommons.org/licenses/pddl/":
              affectedFields.push(selectMe("dataLicence", "odc_pddl"))
              break;
            case "http://creativecommons.org/publicdomain/zero/1.0/":
              affectedFields.push(selectMe("dataLicence", "cc_zero"))
              break;
            case "http://reference.data.gov.uk/id/open-government-licence":
              // Open Government Licence covers data and content
              affectedFields.push(selectMe("dataLicence", "uk_ogl"))
              affectedFields.push(selectMe("contentLicence", "uk_ogl"))
              break;
            case "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf":
              selectMe("dataLicence", "other")
              selectMe("contentLicence", "other")
              fillMe("otherDataLicenceName", "OS OpenData Licence")
              fillMe("otherDataLicenceURL", "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf")
              checkMe("otherDataLicenceOpen", "true")
              fillMe("otherContentLicenceName", "OS OpenData Licence")
              fillMe("otherContentLicenceURL", "http://www.ordnancesurvey.co.uk/docs/licences/os-opendata-licence.pdf")
              checkMe("otherContentLicenceOpen", "true")
              break;
          }
        }

        // Was all this data originally created or gathered by you?
        // Assumption for data.gov.uk
        if (url.indexOf("data.gov.uk") != -1) {
          affectedFields.push(checkMe("publisherOrigin", "true"))
        }

        // Can individuals be identified from this data?
        // Assumption for data.gov.uk
        if (url.indexOf("data.gov.uk") != -1) {
          affectedFields.push(checkMe("dataPersonal", "not_personal"))
        }

        for (var i = 0; i < json.distributions.length; i++) {

          // Is this data machine-readable?
          if (json.distributions[i].structured === true) {
            affectedFields.push(checkMe("machineReadable", "true"))
          }

          // Is this data in a standard open format?
          if (json.distributions[i].open === true) {
            affectedFields.push(checkMe("openStandard", "true"))
          }
        }

        // Does this data change at least daily?
        // Assumption for data.gov.uk
        if (url.indexOf("data.gov.uk") != -1) {
          affectedFields.push(checkMe("frequentChanges", "false"))
        }

        // Does your data documentation contain machine readable documentation for:

        // Title
        if (json.title.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "title"))
        }

        // Description
        if (json.description.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "description"))
        }

        // Release Date
        if (json.release_date.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "issued"))
        }

        // Modification Date
        if (json.modified_date.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "modified"))
        }

        // Frequency of releases
        if (json.update_frequency) {
         affectedFields.push(checkMe("documentationMetadata", "accrualPeriodicity"))
        }

        // Publisher
        if (json.publishers.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "publisher"))
        }

        // Temporal coverage
        if (json.temporal_coverage.start != null && json.temporal_coverage.end != null) {
          affectedFields.push(checkMe("documentationMetadata", "temporal"))
        }

        // Keywords
        if (json.keywords.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "keyword"))
        }

        // Distributions
        if (json.distributions.length > 0) {
          affectedFields.push(checkMe("documentationMetadata", "distribution"))
        }

        // Do the data formats use vocabularies?
        // Assumption for data.gov.uk
        if (url.indexOf("data.gov.uk") != -1) {
          affectedFields.push(checkMe("vocabulary", "false"))
        }

        // Are there any codes used in this data?
        // Assumption for data.gov.uk
        if (url.indexOf("data.gov.uk") != -1) {
          affectedFields.push(checkMe("codelists", "false"))
        }

        // Convert sparse array to jQuery object
        var $affectedFields = $(affectedFields.filter(function(field) { return field; })).map(function() { return this.toArray() })

        callbacks.success($affectedFields);
      })

    // Function to clear callbacks if this request is superceeded
    return function() {
      callbacks.beforeProcessing = function() {}
      callbacks.success = function() {}
      callbacks.fail = function() {}
    }
  }
})
