//= require surveyor/jquery-ui-1.10.0.custom
//= require surveyor/jquery-ui-timepicker-addon
//= require surveyor/jquery.selectToUISlider
//= require surveyor/jquery.maskedinput

// Javascript UI for surveyor
jQuery(document).ready(function(){
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
  jQuery("input[type='text'].datetime").datetimepicker({
    showSecond: true,
    showMillisec: false,
    timeFormat: 'HH:mm:ss',
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });
  jQuery("li.date input").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });
  jQuery("input[type='text'].date").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });
  jQuery("input[type='text'].datepicker").datepicker({
    dateFormat: 'yy-mm-dd',
    changeMonth: true,
    changeYear: true
  });
  jQuery("input[type='text'].time").timepicker({});

  jQuery('.surveyor_check_boxes input[type=text]').change(function(){
    var textValue = $(this).val()
    if (textValue.length > 0) {
      $(this).parent().children().has('input[type="checkbox"]')[0].children[0].checked = true;
    }
  });

  jQuery('.surveyor_radio input[type=text]').change(function(){
    var textValue = $(this).val()
    if (textValue.length > 0) {
      $(this).parent().children().has('input[type="radio"]')[0].children[0].checked = true;
    }
  });

  jQuery("form#survey_form input, form#survey_form select, form#survey_form textarea").change(function(){
    var elements = [$('[type="submit"]').parent(), $('[name="' + this.name +'"]').closest('li')];

    question_data = $(this).parents('fieldset[id^="q_"],tr[id^="q_"]').
      find("input, select, textarea").
      add($("form#survey_form input[name='authenticity_token']")).
      serialize();
    $.ajax({
      type: "PUT",
      url: $(this).parents('form#survey_form').attr("action"),
      data: question_data, dataType: 'json',
      success: function(response) {
        successfulSave(response);
      }
    });
  });

  // http://www.filamentgroup.com/lab/update_jquery_ui_slider_from_a_select_element_now_with_aria_support/
  $('fieldset.q_slider select').each(function(i,e) {
    $(e).selectToUISlider({"labelSrc": "text"}).hide()
  });

  // If javascript works, we don't need to show dependents from
  // previous sections at the top of the page.
  jQuery("#dependents").remove();

  function successfulSave(responseText) {
    // surveyor_controller returns a json object to show/hide elements
    // e.g. {"hide":["question_12","question_13"],"show":["question_14"]}
    jQuery.each(responseText.show, function(){ showElement(this) });
    jQuery.each(responseText.hide, function(){ hideElement(this) });

    jQuery(document).trigger('surveyor-update', responseText);
    return false;
  }

  function showElement(id){
    group = id.match('^g_') ? true : false;
    if (group) {
      jQuery('#' + id).removeClass("g_hidden");
    } else {
      jQuery('#' + id).removeClass("q_hidden");
    }
  }

  function hideElement(id){
    group = id.match('^g_') ? true : false;
    if (group) {
      jQuery('#' + id).addClass("g_hidden");
    } else {
      jQuery('#' + id).addClass("q_hidden");
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

  jQuery("input[data-input-mask]").each(function(i,e){
    var inputMask = $(e).attr('data-input-mask');
    var placeholder = $(e).attr('data-input-mask-placeholder');
    var options = { placeholder: placeholder };
    $(e).mask(inputMask, options);
  });

  // translations selection
  $(".surveyor_language_selection").show();
  $(".surveyor_language_selection select#locale").change(function(){ this.form.submit(); });
  
  // Resolve URLs
  
  var urlRegex = /^(https?:\/\/)[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?/i;
  
  $('input[type=url]').change(function () {
    var el = this
    var regex = new RegExp("^(https?:\/\/)[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?");
    if(el.value.match(urlRegex)) {
      $(el).parent().spin({lines: 8, length: 4, width: 3, radius: 5, direction: 1, color: '#000', speed: 1, trail: 60, top: '70px', left: '750px', zIndex: 9});
      $.getJSON('/resolve', { url: el.value } )
        .done(function(json) {
          $(el).parent().spin(false);
          if (json.status == 200) {
            $(el).attr('class', 'string')
            $(el).parent().next('.url_error').attr('class', 'span7 url_error hidden');
          } else {
            $(el).attr('class', 'string fail')
            $(el).parent().next('.url_error').attr('class', 'span7 url_error');
          }
        });
    }
  })
  
  // Data Kitten Stuff
  
  // Utility function to populate input fields by identifier
  function fillMe(identifier, val) {
    $('[data-reference-identifier="'+ identifier +'"] input.string, [data-reference-identifier="'+ identifier +'"] select').val(val)
  }
  
  // Utility function to check input fields by identifier
  function checkMe(identifier, value) {
    $('[data-reference-identifier="'+ identifier +'"] [value="'+ value +'"]').prop('checked', true)
  }
  
  $('[data-reference-identifier="documentationUrl"] input.string').change(function () {
    var el = this
    var regex = new RegExp("^(https?:\/\/)[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?");
    if(el.value.match(urlRegex)) {
      $(el).parent().spin({lines: 8, length: 4, width: 3, radius: 5, direction: 1, color: '#000', speed: 1, trail: 60, top: '70px', left: '750px', zIndex: 9});
      $.getJSON('/autofill', { url: el.value } )
        .done(function(json) {
          // Title
          fillMe("dataTitle", json.title)
          
          if (json.publishers.length > 0) {
            // Publisher name
            fillMe("publisher", json.publishers[0].name)
            // Publisher URL
            fillMe("publisherUrl", json.publishers[0].homepage)
          }
          
          // Data type
                
          if (json.update_frequency.length == 0 && json.distributions.length == 1) {
            // One-off release of a single dataset
            checkMe("releaseType", 4)
          } else if (json.update_frequency.length == 0 && json.distributions.length > 1) {
            checkMe("releaseType", 3)
            // One-off release of a set of related datasets
          } else if (json.update_frequency.length > 0 && json.distributions.length > 1) {
            // Ongoing release
            checkMe("releaseType", 5)
          }
          
          // A service or API for accessing open data
          if (json.title.indexOf("API") >= 0 || json.description.indexOf("API") >= 0 ) {
            checkMe("releaseType", 6)
          }
                      
          // Rights information
          if (json.rights) {
            // Yes, you have the rights to publish this data as open data
            checkMe("publisherRights", 9)
            // Rights statement
            fillMe("copyrightURL", json.rights.uri)
            
            // Data License
            switch(json.rights.dataLicense) {
              case "http://opendatacommons.org/licenses/by/":
                fillMe("dataLicence", 34)
                break;
              case "http://opendatacommons.org/licenses/odbl/":
                fillMe("dataLicence", 35)
                break;
              case "http://opendatacommons.org/licenses/pddl/":
                fillMe("dataLicence", 36)
                break;
              case "http://creativecommons.org/publicdomain/zero/1.0/":
                fillMe("dataLicence", 37)
                break;
              case "http://reference.data.gov.uk/id/open-government-licence":
                fillMe("dataLicence", 38)
                break;
            }
            
            // Content License
            switch(json.rights.contentLicense) {
              case "http://creativecommons.org/licenses/by/2.0/uk/":
                fillMe("contentLicence", 52)
                break;
              case "http://creativecommons.org/licenses/by-sa/2.0/uk/":
                fillMe("contentLicence", 53)
                break;
              case "http://creativecommons.org/publicdomain/zero/1.0/":
                fillMe("contentLicence", 54)
                break;
              case "http://reference.data.gov.uk/id/open-government-licence":
                fillMe("contentLicence", 55)
                break;
            }
          } else if (json.licenses) {
            // Yes, you have the rights to publish this data as open data
            checkMe("publisherRights", 9)
          
            // Data License
            switch(json.licenses[0].uri) {
              case "http://opendatacommons.org/licenses/by/":
                fillMe("dataLicence", 34)
                break;
              case "http://opendatacommons.org/licenses/odbl/":
                fillMe("dataLicence", 35)
                break;
              case "http://opendatacommons.org/licenses/pddl/":
                fillMe("dataLicence", 36)
                break;
              case "http://creativecommons.org/publicdomain/zero/1.0/":
                fillMe("dataLicence", 37)
                break;
              case "http://reference.data.gov.uk/id/open-government-licence":
                // Open Government Licence covers data and content
                fillMe("dataLicence", 38)
                fillMe("contentLicence", 55)
                break;
            }
        
          }
          
          // Was all this data originally created or gathered by you? 
          // Assumption for data.gov.uk
          if (el.value.indexOf("data.gov.uk") != -1) {
            checkMe("publisherOrigin", 13)
          }
          
          // Can individuals be identified from this data?
          // Assumption for data.gov.uk
          if (el.value.indexOf("data.gov.uk") != -1) {
            checkMe("dataPersonal", 68)
          }
          
          for (var i = 0; i < json.distributions.length; i++) {
            
            // Is this data machine-readable?
            if (json.distributions[i].structured === true) {
              checkMe("machineReadable", 151)
            }
            
            // Is this data in a standard open format?
            if (json.distributions[i].open === true) {
              checkMe("openStandard", 153)
            }
          }
          
          // Does this data change at least daily?
          // Assumption for data.gov.uk
          if (el.value.indexOf("data.gov.uk") != -1) {
            checkMe("frequentChanges", 103)
          }
                      
          // Does your data documentation contain machine readable documentation for:
          
          // Title
          if (json.title.length > 0) {
            checkMe("documentationMetadata", 185)
          }

          // Description
          if (json.description.length > 0) {
            checkMe("documentationMetadata", 186)
          }

          // Release Date
          if (json.release_date.length > 0) {
            checkMe("documentationMetadata", 187)
          }
          
          // Modification Date
          if (json.modified_date.length > 0) {
            checkMe("documentationMetadata", 188)
          }
          
          // Publisher
          if (json.publishers.length > 0) {
            checkMe("documentationMetadata", 193)
          }
          
          // Temporal coverage
          if (json.temporal_coverage.start != null && json.temporal_coverage.end != null) {
            checkMe("documentationMetadata", 195)
          }
          
          // Frequency of releases
          if (json.update_frequency) {
            checkMe("documentationMetadata", 189)
          }
          
          // Keywords
          if (json.keywords.length > 0) {
            checkMe("documentationMetadata", 197)
          }
          
          // Distributions
          if (json.distributions.length > 0) {
            checkMe("documentationMetadata", 198)
          }
          
          // Do the data formats use vocabularies?
          // Assumption for data.gov.uk
          if (el.value.indexOf("data.gov.uk") != -1) {
            checkMe("vocabulary", 209)
          }
          
          // Are there any codes used in this data? 
          // Assumption for data.gov.uk
          if (el.value.indexOf("data.gov.uk") != -1) {
            checkMe("codelists", 212)
          }
          
          // Contact email address
          fillMe("contactEmail", json.publishers[0].mbox)
          
          // Trigger status panel update
          $('#status_panel').trigger('update');
          
        });
    }
  });

});
