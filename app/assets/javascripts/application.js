//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require twitter/bootstrap/rails/confirm
//= require underscore
//= require_tree .

/* global $, skrollr, alert, Hogan */

// whether or not the homepage map should be loaded
window.enableMap = document.querySelectorAll && Modernizr.svg;

$(document).ready(function($){
  //////
  // Rails support
  //

  'use strict';

  // Display when an remote form failed
  $(document).on('ajax:error', 'form[data-remote-error-message]', function(){
    var message = $(this).data('remote-error-message'),
        $target = $('.form-errors', this);

    if($target.size()){
      // create a div to show the message in
      $('<div>', {'class':'alert alert-box alert-alert'})
        .append($('<h3>',{text:message}))
        .appendTo($target);
    } else {
      alert(message);
    }

  }).on('ajax:beforeSend.rails', 'form[data-remote-error-message]', function(){
    $('.form-errors', this).empty();
  });

  // Skrollr data settings
  var bleed = $('body.odi-bleed').attr({
    'data-0':'background-position:center -480px',
    'data-2500':'background-position:center 1000px'
  });


  // don't enable on touch devices, fix at:
  // https://github.com/Prinzhorn/skrollr#what-you-need-in-order-to-support-mobile-browsers
  // though primary concern is for it not to break for now
  var touch = 'ontouchstart' in window;
  if (bleed.size() && !touch) skrollr.init({forceHeight: false});

  // Event to close menus when clicking away off them
  var openMenu = false;
  $(document).on('click', function() {
    if (openMenu) {
      openMenu.removeClass('active');
      openMenu.data('target').removeClass('active');
      openMenu = false;
    }
  });

  // Bind related elements for each toggle button
  $('[data-dropdown=toggle]').each(function() {
    var self = $(this);
    self.data('target', $(self.data('target')));
    self.data('parent', $(self.data('parent')));

    // Event to prevent menus being closed when clicked on them
    self.data('target').click(function(e) { e.stopPropagation(); });
  });

  // Trigger dropdown buttons
  $(document).on('click', '[data-dropdown=toggle]', function() {
    var self = $(this);
    var active = !self.data('target').hasClass('active');

    self.data('parent').find('[data-dropdown=toggle]').each(function() {
      var self = $(this);
      self.removeClass('active');
      self.data('target').removeClass('active');
    });

    self.toggleClass('active', active);
    self.data('target').toggleClass('active', active);
    openMenu = active && self;

    return false;
  });

  // Toggles content based on a button
  $('[data-content=toggle]').each(function() {
    var self = $(this);
    self.data('target', self.find(self.data('target')));
    self.data('button', self.find(self.data('button')));

    self.data('button').click(function() {
      self.data('target').animate({opacity: 'toggle'}, 250);
    });
  });

  $('[data-content=highlight]').click(function() {
    this.select();
  });

  // display confirmation of clicking certain buttons
  $(document).on('click', '[data-btn-confirmable]', function(){
    var $this = $(this),
        message = $this.data('btn-confirmable');

    if(message) $this.is('input') ? $this.val(message) : $this.text(message);

    $this.addClass('btn-confirmed disabled');

  });


  //////
  // Questionnaire

  // a map from reference_id to the relevant fieldset (DOM, not $wrapped)
  var reference_id_els = {};
  var $surveyElements = $('[data-reference-identifier]');
  $surveyElements.each(function(){
    reference_id_els[$(this).data('reference-identifier')] = this;
  });

  // The fieldset surrounding an input is the base of a question being 'active', it will
  // - have an 'active' class added
  // - emit 'odc.focus' & 'odc.blur' events (?)
  $surveyElements.on('mouseenter', function(){
    $(this).addClass('active').data('mouseover', true).trigger('_focus');
  }).on('mouseleave', function(){;
    $(this).removeClass('active').data('mouseover', false).trigger('_blur');
  });

  // trigger the highlighting of fieldsets
  $('#surveyor')
    .on('focus', 'fieldset', function(){
      $(this).addClass('active').trigger('_focus');
    })
    .on('blur', 'fieldset', function(){
      if (!$(this).data('mouseover')) {
        $(this).removeClass('active').trigger('_blur');
      }
    });

  // binding the text of this to the value of a
  // particular input, keyed by data-reference-identifier
  // (this is for the the title to show the questionnaire title)
  $('[data-bind-to-input]').each(function(){
    var $bound = $(this),
        original = $bound.text(),
        el = reference_id_els[$bound.data('bind-to-input')];

    $(el).find('input').on('keyup', function(){
      $bound.text($(this).val() || original);
    });
  });


  // elements that have to be shown along with the fieldsets
  $('[data-meta-for]').each(function() {
    var ref_id = $(this).data('meta-for'),
        $el = $(reference_id_els[ref_id]),
        $row = $(this).closest('.question-row'),
        metas = $el.data('metas') || [];

    metas.push(this);
    $el.data('metas', metas);

    if ($el.hasClass('input')) {
      $row.data('input-metas', $row.data('input-metas') || []);
      $row.data('input-metas').push(this);
    }
  });

  var $currentRow = $();

  // Moves highlighting to a row on hover and tab, removes focus from the previous row
  $surveyElements.filter('.question-row').on('_focus', function() {
    if ($currentRow[0] != $(this).closest('.question-row')[0]) {

      $($currentRow.data('metas')).hide();
      $($currentRow.data('input-metas')).hide();

      $currentRow = $(this).closest('.question-row');
    }

    $($(this).data('metas')).show();
    $($currentRow.data('metas')).show();

  });

  // Shows the appropriate information for a radio button or checkbox
  $surveyElements.filter('.input').on('_focus', function() {
    $($currentRow.data('input-metas')).hide();
    $($(this).data('metas')).show();
  });

  // Removes highlighting and information on mouseleave
  $surveyElements.on('mouseleave', function(){
    $($currentRow.data('metas')).hide();
    $($currentRow.data('input-metas')).hide();

    $currentRow = $();
  });

  // deal with accordion section changes
  $('.survey-section .collapse').on('show', function(e){
    if (e.target == this) {
      $(this).prev().removeClass('inactive');
    }
  }).on('hidden', function(e){
    if (e.target == this) {
      $(this).prev().addClass('inactive');
    }
  });

  $('.affixed').each(function(){
    var $this = $(this),
        h = $this.height();

    // lock the height and affix the child node
    $this.height(h).children().affix({ offset: $this.position() });

    $('#status_panel').affix({offset:$this.position(), top:10});

  });

  // Old IE only supports :hover on anchors
  $('#status_panel').hover(function(){
    $(this).addClass('hover');
  }, function(){
    $(this).removeClass('hover');
  });

  $('#status_panel').click(function(){
    $(this).toggleClass('stick');
  });

  // Start with status panel in sticky mode, then hide after 10 seconds
  $('#status_panel').toggleClass('stick');
  setTimeout(function() {
    $('#status_panel').removeClass('stick');
  },5000);

  $('.survey-intro .submit').click(function() {
    $(this).addClass('disabled');
    $(this).removeClass('error');
    $(this).popover('show');
    var form = $(this.form);
    $.ajax({
      type: 'POST',
      cache: false,
      url: form.attr('action') + ".json",
      data: form.serialize(),
      success: function(data) {
        window.location.replace(data.survey_path)
      },
      error: function(xhr) {
        $('.survey-intro .submit').removeClass('disabled')
        $('.survey-intro .submit').addClass('error')
        var popover = $('.survey-intro .submit').data('popover')
        if (xhr.status == 404) {
          popover.options.content = "There was a problem with your URL, please check, or fill out the explanation"
          $("#start_url_explanation").attr('style', 'display: block')
        } else {
          popover.options.content = "Sorry, an error occurred. Please try again."
        }
        popover.show()
        setTimeout(function(){ popover.hide() }, 3000);
      },
      timeout: 120000
    })
    return false;
  });

  // scroll to question / repeated section
  var $question = $(document.location.hash);
  if ($question.length !== 0) {
    // open up survey section
    $question
      .parents('.survey-section')
      .find('ul')
      .on('shown', function () {
        // scroll to the question (taking into account header)
        $('html').scrollTop($question.offset().top - 130);
      })
      .collapse('show');
  }

  // Open sections that contain incomplete mandatory questions
  if ($('#surveyor').hasClass('highlight-mandatory')) {
    $('.survey-section:has(.mandatory.no-response:not(.q_hidden))')
      .find('ul')
      .collapse('show');
  }


  // Questionnaire status panel
  $('#status_panel').on('update', function(){
    var panel = this;

    // progress url set as data attribute
    var url = $(this).data('progress-url');

    $(panel).addClass('loading');

    $.getJSON(url)
    .then(function(data){
      // console.log("url:", url)

      $(panel).removeClass('loading');

      var levels = ['basic', 'pilot', 'standard', 'exemplar'];

      var pending = data.mandatory,
          complete = data.mandatory_completed,
          percentage, attained = 'none';

      _.each(levels, function(level){

        // rolling values
        pending  += _.filter(data.outstanding, has_level(level)).length;
        complete += _.filter(data.entered,     has_level(level)).length;

        percentage = ((complete / (pending + complete))*100)

        $('#bar-' + level).width(percentage + '%');

        if(percentage === 100){attained = level}

        // debug
        // console.log("Level: %s, pending: %d, complete: %d, percentage: %f", level, pending, complete, percentage)
      });

      $('#panel_handle')
        // removed any 'attained-' classes
        .toggleClass(function(i, name){return name.indexOf('attained-') === -1})
        .addClass('attained-' + attained);


      function has_level(name){
        return function(item){
          return item.indexOf(name+'_') === 0
        }
      }

    });
  });


  // when surveyor has displayed/hidden elements
  $(document).on('surveyor-update', function(){
    $('#status_panel').trigger('update');
  });

  // also on load
  $('#status_panel').trigger('update');


  // Placeholders for <= IE9 - https://github.com/mathiasbynens/jquery-placeholder

  // If the browser supports HTML5 placeholder, it won't do anything

  $('input, textarea').placeholder();


  // ## dashboard

  // initialise some of the popover
  $('.popdown').popover({
    placement:'bottom',
    trigger:'hover'
  });


  // search typeahead
  $('.typeahead-search').typeahead([{
      name:'datasets',
      header: '<h3>Datasets</h3>',
      template: '<p class="attained attained-{{attained_index}}">{{value}}</p>',
      engine: Hogan,
      remote: {
        url:'/datasets/typeahead?mode=dataset&q=%QUERY'
      }
    },
    {
      name:'publisher',
      header: '<h3>Publisher</h3>',
      remote: {
        url:'/datasets/typeahead?mode=publisher&q=%QUERY'
      }
    },
    {
      name:'jurisdiction',
      header: '<h3>Jurisdiction</h3>',
      remote: {
        url:'/datasets/typeahead?mode=country&q=%QUERY'
      }
    }
  ])
  .on('typeahead:selected typeahead:autocompleted', function(e, datum){
    if(datum.path){ document.location = datum.path; }
  });

  // Stop the jump to the top of the page when the delete dialog is confirmed.
  // placeholder till bluerail/twitter-bootstrap-rails-confirm#9 gets published
  $(document).on('click', "#confirmation_dialog [href='#']", function(e){
    e.preventDefault();
  })

  .on('click', '.dataset .show-more, .dataset .hide-more', function(){
    $(this).parents('.dataset').toggleClass('expanded', $(this).hasClass('show-more'));
  })

  .on('click', '.join-discussion a', function(e){
    e.preventDefault();
    var top = $('.juvia-add-comment-form').prev().offset().top;
    $('body').animate({scrollTop:top})
  });

  var certificateBody = $('.certificate-data');

  certificateBody.click(function() {
    certificateBody.find('.odc-popover').popover('hide');
  });

  certificateBody.find('.odc-popover').each(function() {
    var self = $(this);
    self.popover({
      trigger: 'manual',
      html: true,
      content: function() {
        // pull out the content from the child element (hidden with css)
        $(this).data('visible', true);
        return $('.odc-popover-content', this).html();
      },
      template: '<div class="popover popover-light"><div class="arrow"></div>'+
                '<h3 class="popover-title"></h3><div class="popover-content"></div></div>'
    });
  });

  certificateBody.on('click', '.odc-popover', function() {
    certificateBody.find('.odc-popover').not(this).popover('hide');
    $(this).popover('toggle');
    return false;
  });

  certificateBody
    .on('mouseover', '.answer', function(){$(this).toggleClass('odc-popover-active', true)})
    .on('mouseout',  '.answer', function(){$(this).toggleClass('odc-popover-active', false)});

  // Replace select boxes visually
  $('#surveyor select').each(function() {
    var self = $(this);

    var selectBox = $('<div class="select-box">');
    self.wrap($('<div class="select-wrapper">')).before(selectBox);
    selectBox.text(self.find(':selected').text());

    self.change(function(e) {
        selectBox.text(self.find(':selected').text());
    });
  });
});
