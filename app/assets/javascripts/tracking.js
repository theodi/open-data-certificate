var Tracking = (function($){
    "use strict;"

    var last_question = {
        question_id: null,
        question_text: null
    };

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
                        // made up curve to increase logging frequency
                        // towards the 100% mark
                        var mark = 140*Math.log((max+100)/100);
                        if ( scroll > mark ) {
                            ga('send', 'event', 'Questionnaire', 'scroll', 'page', scroll);
                            max = scroll;
                        }
                    }
                });
            }

            // Listen to focus events on text inputs
            // find the question id and label
            $('.container input.string').on('focus', function() {
                var name = $(this).attr('name').replace('string_value', 'question_id');
                last_question.question_id = $(this).parents('.container').find('[name="' + name + '"]').val();
                last_question.question_text = $('label[for="' + $(this).attr('id') + '"]').text();
            });
            // Listen to click events on multiple choice questions
            $('.container .choice label').on('click', function() {
                var name = $(this).find('input').attr('name').replace('answer_id', 'question_id');
                last_question.question_id = $(this).parents('.container').find('[name="' + name + '"]').val();
                last_question.question_text = $(this).parents('.container').find('label.question_label').text();
            });
            // Track last answered question text and ID
            $(window).on('beforeunload', function() {
                if ( last_question.question_id ) {
                    ga('send', 'event', 'Questionnaire', 'last-question',
                        last_question.question_text.trim(), last_question.question_id);
                }
            });
        },

        event: function(category, action, label) {
            ga('send', 'event', category, action, label);
        }
    }
})(jQuery);
