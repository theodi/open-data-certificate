$(document).ready(function($){

  function isUrlValid(url) {
    return /^(https?|s?ftp):\/\/(((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:)*@)?(((\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5])\.(\d|[1-9]\d|1\d\d|2[0-4]\d|25[0-5]))|((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.?)(:\d*)?)(\/((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)+(\/(([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)*)*)?)?(\?((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|[\uE000-\uF8FF]|\/|\?)*)?(#((([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(%[\da-f]{2})|[!\$&'\(\)\*\+,;=]|:|@)|\/|\?)*)?$/i.test(url);
  }

  var subsetTypeahead = {
    tags: undefined,
    organizations: undefined,
    element: $('#subset')
  };

  var handleOrganizations = function(data){
    var orgArray = [];
    if (data && data.success) {
      $.each(data.result, function (i, org) {
        orgArray.push({ value: org.title, name: org.name, type: 'organization' });
      });
      subsetTypeahead.organizations = orgArray;
      $(subsetTypeahead).trigger('checkReady');
    } else {
      return false;
    }
  };

  var handleTags = function(data){
    var tagsArray = [];
    if (data && data.success) {
      $.each(data.result, function (i, tag) {
        tagsArray.push({ value: tag.display_name, name: tag.name, type: 'tags' });
      });
      subsetTypeahead.tags = tagsArray;
      $(subsetTypeahead).trigger('checkReady');
    } else {
      return false;
    }
  };

  window.handleTags = handleTags;
  window.handleOrganizations = handleOrganizations;

  var requestSubsets = function(ckan_url){
    var organizations_url = "";
    var tags_url = "";
    var organizations_path = "3/action/organization_list?all_fields=true";
    var tags_path = "3/action/tag_list?all_fields=true";

    if (isUrlValid(ckan_url)){
      if (ckan_url[ckan_url.length-1] != "/"){ ckan_url = ckan_url + "/"; }
      organizations_url = ckan_url + organizations_path;
      tags_url = ckan_url + tags_path;
    } else {
      return false;
    }

    var orgsOptions = { url: organizations_url, dataType: "jsonp", jsonpCallback: "handleOrganizations", timeout: 5000 };
    var tagsOptions = { url: tags_url, dataType: "jsonp", jsonpCallback: "handleTags", timeout: 5000 };
    
    $.ajax(orgsOptions);
    $.ajax(tagsOptions);
  };

  var bindTypeahead = function(subsetTypeahead){ 
    subsetTypeahead.element.typeahead([{
      hint: false, minLength: 3,
      name:'organisations-'+(new Date-0),
      header: '<h3>Organisations</h3>',
      template: '<p class="">{{ value }}</p>',
      engine: Hogan,
      local: subsetTypeahead.organizations
    }, {
      hint: false, minLength: 3,
      name:'tags-'+(new Date-0),
      header: '<h3>Tags</h3>',
      template: '<p class="">{{ value }}</p>',
      engine: Hogan,
      local: subsetTypeahead.tags
    }]).on('typeahead:selected typeahead:autocompleted', function(e, datum){
      $('div#'+datum.type+'-subset').show();
      $('div#'+datum.type+'-subset').find('input').val(datum.name);
      subsetTypeahead.element.typeahead('setQuery', '');
    });
  };

  $(subsetTypeahead).on('checkReady', function () {
    if (subsetTypeahead.tags && subsetTypeahead.organizations){
      bindTypeahead(subsetTypeahead);
      subsetTypeahead.element.removeAttr('disabled');
      subsetTypeahead.element.css('background-color','white');
    } else {
      subsetTypeahead.element.attr('disabled','disabled');
    }
  });

  subsetTypeahead.element.attr('disabled','disabled');
  $('div#tags-subset,div#organization-subset').hide();
  $('div#tags-subset,div#organization-subset').off().click(function(e){ 
    $(this).children('input').val(''); $(this).hide(); 
  });

  var setupSubsets = function(){
    subsetTypeahead.element.typeahead('destroy');
    subsetTypeahead.element.off();
    subsetTypeahead.tags = undefined;
    subsetTypeahead.organizations = undefined;
    $('div#tags-subset,div#organization-subset').trigger('click');
    subsetTypeahead.element.attr('disabled','disabled');
    var ckan_url = $("#certification_campaign_url").val();
    requestSubsets(ckan_url);
  }

  $("#certification_campaign_url").change(setupSubsets);
  if($("#certification_campaign_url").val()){ setupSubsets(); }

  $('#endpoint_check').click(function(){
    var checkOptions = {
      method: 'PUT',
      url: $(this).attr('data-url'),
      data: { campaign_url: $('#certification_campaign_url').val() },
      dataType: 'json',
      beforeSend: function(){ 
        $('#endpoint_check i').attr('class', 'icon-loading icon-spin icon-refresh'); 
        $('#endpoint_check span').text('Checking...'); 
      },
      success: function(d) {
        if (d.redirect){ $('#certification_campaign_url').val(d.redirect); }
        if (d.success) { 
          $('#endpoint_check i').attr('class', 'icon-ok'); 
          $('#endpoint_check span').text('Valid'); 
        } else { 
          $('#endpoint_check i').attr('class', 'icon-exclamation-sign'); 
          $('#endpoint_check span').text('Invalid'); 
        }
      },
      error: function(d){ 
        $('#endpoint_check i').attr('class', 'icon-repeat'); 
        $('#endpoint_check span').text('Please retry'); 
      }
    };
    $.ajax(checkOptions);
  });

});