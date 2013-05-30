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


  // binding the text of this to the value of a
  // particular input (keyed by data-reference-identifier)
  $('[data-bind-to-input]').each(function(){
    var $bound = $(this),
        original = $bound.text();

    // not very efficient, as a new listener for every bound item though
    // we're only using this once, on one page, so it's not so bad
    $(document).on('keyup', '[data-reference-identifier]', function(){
      $bound.text($(this).val() || original);
    });

  });

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
