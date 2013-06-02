//= require jquery
//= require jquery_ujs
//= require_tree .
//= require twitter/bootstrap

$(function(){
	// Skrollr data settings
	var bleed = $('body.odi-bleed').attr({
		'data-0':'background-position:0 -450px',
		'data-2500':'background-position:0 1000px'
	});

	if (bleed.size()) skrollr.init({forceHeight: false});

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

  $('.embed-code textarea').click(function() {
    this.select();
  });



  //////
  // Questionnaire


  /*
    The fieldset surrounding an input is the base of a question being 'active', it will
      - have an 'active' class added
      - emit 'odc.focus' & 'odc.blur' events (?)
  */


  // trigger the highlighting of fieldsets
  $('#surveyor')
    .on('focus', 'input, select, textarea', function(){
      $(this).parents('fieldset').addClass('active').trigger('_focus');
    })
    .on('blur', 'input, select, textarea', function(){
      $(this).parents('fieldset').removeClass('active').trigger('_blur');
    });


  // a map from reference_id to the relevant fieldset (DOM, not $wrapped)
  var reference_id_els = {};
  var $baseFieldsets = $('[data-reference-identifier]');
  $baseFieldsets.each(function(){
    reference_id_els[$(this).data('reference-identifier')] = this;
  });

  $baseFieldsets.on('mouseover', function(){
    $(this).addClass('active').trigger('_focus');
  }).on('mouseout', function(){
    $(this).removeClass('active').trigger('_blur');
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
  $('[data-meta-for]').each(function(){
    var ref_id = $(this).data('meta-for'),
        $el = $(reference_id_els[ref_id]),
        metas = $el.data('metas') || [];
    metas.push(this);
    $el.data('metas', metas);
  });
  $baseFieldsets.on('_focus', function(){
    $($(this).data('metas')).show();
  }).on('_blur', function(){
    $($(this).data('metas')).hide();
  });


  // deal with accordion section changes
  $('.survey-section .collapse').on('show', function(){
    $(this).prev().removeClass('inactive');
  }).on('hidden', function(){
    $(this).prev().addClass('inactive');
  });

  $('.affixed').each(function(){
    var $this = $(this),
        h = $this.height();

    // lock the height and affix the child node
    $this.height(h).children().affix({ offset: $this.position() });

    $('#status_panel').affix({offset:$this.position(), top:10});

  });


  // major massive massive hack
  //
  // This collects all the sections that are requirements, and
  // bundles them into the aside of the previous question (that
  // they hopefully pertain to)
  /*
  var $current;
  $('.survey-section > ul > li > fieldset').each(function(){
    var $this = $(this),
        ref_id = $this.data('reference-identifier');
    if(ref_id){
      $current = $this;
    } else if($current){
      $this.remove().appendTo($current.find('aside'));
    }
  });
  */


  // Old ie only supports :hover on anchors
  $('#status_panel').hover(function(){
    $(this).addClass('hover');

    // also make the bars update
    $(this).trigger('update');
  }, function(){
    $(this).removeClass('hover');
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

});
