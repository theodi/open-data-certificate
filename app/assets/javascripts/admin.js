jQuery(function($) {
    $('.typeahead-user-search').typeahead([{
        name:'user-search',
        header: '<h3>Select a user</h3>',
        template: '{{user}}',
        engine: Hogan,
        remote: {
        url:'/admin/typeahead?q=%QUERY'
        }
    }]).on('typeahead:selected typeahead:autocompleted', function(e, datum){
        if(datum.path){ document.location = datum.path; }
    });
});
