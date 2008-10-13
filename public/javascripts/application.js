// This is to force all requests from jquery to accept only javascript or json responses
jQuery.ajaxSetup({ 
  'beforeSend': function(xhr) { xhr.setRequestHeader("Accept", "text/javascript, application/json"); }
});