var pKey = 80, rKey = 82, sKey = 83, lKey = 76;

var event_type = $.browser.mozilla? "keypress" : "keydown";
$(function () {
  $(document).bind(event_type, function(e){
    var charCode = String.fromCharCode(e.which);
    var keymap = {P: 'pomodoro', S: 'short', L: 'long', R: 'reset'};
    // console.log(e.type,"keyCode:"+e.keyCode,"which:"+e.which,"charCode:"+charCode);
    if(e.ctrlKey){
      if($.inArray(e.which, [pKey,rKey,sKey,lKey]) > -1){
        console.log(charCode);
        $('#' + keymap[charCode]).closest('form').submit();
      }
    }
    if(e.shiftKey) {
      if(e.which == 63 || e.which == 191) {$("#help").toggle()}
    }
  });
  $("#close-help a.close").click(function() {$("#help").hide();})
})
