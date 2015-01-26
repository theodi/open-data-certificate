var Tracking = (function($){
    "use strict;"

    return {
        init: function() {
            // Track show/hide of modal popups
            $('.modal-wide').on('shown', function() {
                ga('send', 'event', 'Popup', 'show', $(this).attr('id'));
            }).on('hide', function() {
                ga('send', 'event', 'Popup', 'hide', $(this).attr('id'));
            });

            // Track advanced search usage
            $('.advanced-search [type=button]').on('click', function(){
                ga('send', 'event', 'Search', 'toggle', 'advanced-options');
            });

            // Track show hide of collapsed sections in questionnaire
            $('.survey-section .collapse').on('shown', function(e){
                var section = $(this).parent('section').attr('id');
                ga('send', 'event', 'Questionnaire', 'show', section);
            }).on('hide', function() {
                var section = $(this).parent('section').attr('id');
                ga('send', 'event', 'Questionnaire', 'hide', section);
            });

            $('.btn.publish-certificate').on('click', function(e) {
                var identifier = $(this).data('code');
                ga('send', 'event', 'Questionnaire', 'publish', identifier);
            });

            // Track scroll position on page
            if ($('body.questionnaire').length > 0) {
                // furthest scroll point
                var max = 0;
                // if a section is expanded reset scroll position
                // as document has gotten much longer
                $('.survey-section .collapse').on('shown', function(e){
                    max = 0;
                });
                // if scroll position is more than 1.5 times further down the page
                // log this as a scroll event
                $(window).on('scroll', function(e) {
                    var height = $('body').height();
                    var position = $('body').scrollTop();
                    if ( position > 0 && position <= height) {
                        var scroll = parseInt(100*position/height);
                        if ( scroll > 1.5*max ) {
                            ga('send', 'event', 'Questionnaire', 'scroll', 'page', scroll);
                            max = scroll;
                        }
                    }
                });
            }
        },

        event: function(category, action, label) {
            ga('send', 'event', category, action, label);
        }
    }
})(jQuery);
