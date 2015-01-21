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
        },

        event: function(category, action, label) {
            ga('send', 'event', category, action, label);
        }
    }
})(jQuery);
