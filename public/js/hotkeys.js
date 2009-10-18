var isCtrl = false;
var ctrlKey = 17;
var pKey = 80;
var sKey = 83;
var lKey = 76;

$(document).keyup(function(e){
  if(e.which == ctrlKey) isCtrl = false;
});

$(document).keydown(function(e){
  // console.log(e.type,"keyCode:"+e.keyCode,"which:"+e.which,"charCode:"+String.fromCharCode(e.which));
  if(e.which == ctrlKey) isCtrl = true;
  if(isCtrl){
    if($.inArray(e.keyCode, [pKey,sKey,lKey]) > -1){
      $('#' + String.fromCharCode(e.which).toLowerCase()).submit();
    }
  }
});
