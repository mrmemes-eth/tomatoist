var pKey = 80;
var sKey = 83;
var lKey = 76;

var event_type = $.browser.mozilla? "keypress" : "keydown";
$(function () {
  $(document).bind(event_type, function(e){
    //console.log(e.type,"keyCode:"+e.keyCode,"which:"+e.which,"charCode:"+String.fromCharCode(e.which));
    if(e.ctrlKey){
      if($.inArray(e.which, [pKey,sKey,lKey]) > -1){
        $('#' + String.fromCharCode(e.which).toLowerCase()).submit();
      }
    }
    if(e.shiftKey) {
      if(e.which == 63 || e.which == 191) {$("#help").toggle()}
    }
  });
  $("#close-help a.close").click(function() {$("#help").hide();})
})
