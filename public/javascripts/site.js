document.observe('dom:loaded', function() {
   $$('[rel=hide-on-load]').each(function(s) {
       s.hide();
   });
});