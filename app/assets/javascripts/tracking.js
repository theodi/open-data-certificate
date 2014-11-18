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
        }
    }
})(jQuery);
