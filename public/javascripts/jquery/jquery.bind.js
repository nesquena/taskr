$.bind = function() {
   var _func = arguments[0] || null;
   var _obj = arguments[1] || this;
   var _args = $.grep(arguments, function(v, i) {
       return i > 1;
   });

   return function() {
     return _func.apply(_obj, _args);
   };
};