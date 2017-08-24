//add in progress poller
$(document).ready(function($){
  
  var certificatesWrapper = $('div#certificates-wrapper');

  var updateCertificates = function(url) {
    var opts = {
      method: 'GET',
      url: url,
      data: {},
      dataType: 'script',
      beforeSend: function(){},
      error: function(){},
      complete: function(){}
    };
    $.ajax(opts);
  };

  var tout = 2000;
  
  certificatesWrapper.on('tableUpdated', function(e) {
    ongoing = certificatesWrapper.attr('data-ongoing');
    if (ongoing === "true"){
      console.log(tout);
      url = certificatesWrapper.attr('data-refresh-url');
      setTimeout(function(){ updateCertificates(url); }, tout);
    }
    tout = 8000;
  });
  
  certificatesWrapper.trigger('tableUpdated');
});