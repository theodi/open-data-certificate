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
        }
    }
})(jQuery);
