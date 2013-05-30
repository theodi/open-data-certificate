// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require twitter/bootstrap

$(function(){
	// hack
	var bleed = $('body.odi-bleed').attr({
		'data-0':'background-position:0 -450px',
		'data-2500':'background-position:0 1000px'
	});

	if(bleed.size()) skrollr.init({forceHeight: false});



  //////
  // Questionnaire 


  /*
    The fieldset surrounding an input is the base of a question being 'active', it will
      - have an 'active' class added
      - emit 'odc.focus' & 'odc.blur' events (?)
  */


  // trigger the highlighting of fieldsets
  $('#surveyor')
    .on('focus', 'input', function(){
      $(this).parents('fieldset').addClass('active').trigger('_focus');
    })
    .on('blur', 'input', function(){
      $(this).parents('fieldset').removeClass('active').trigger('_blur');
    });


  // a map from reference_id to the relevant fieldset (DOM, not $wrapped)
  var reference_id_els = {};
  var $baseFieldsets = $('[data-reference-identifier]fieldset');
  $baseFieldsets.each(function(){
    reference_id_els[$(this).data('reference-identifier')] = this;
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

  });

});
