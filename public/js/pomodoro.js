String.prototype.lpad = function(padString, length) {
  var str = this;
  while (str.length < length)
    str = padString + str;
  return str;
}

$.countdown.setDefaults({alwaysExpire: true, format: 'MS'})
soundManager.url = 'swf/'

var isCtrl = false;
var ctrlKey = 18;
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

function minToMil(minutes){
  return 1000*60*minutes;
}

function pomo(period){
  switch(period){
    case 'short':    return { message:'Short break', duration:minToMil(5)  };
    case 'long':     return { message:'Long break',  duration:minToMil(15) };
    case 'pomodoro': return { message:'Pomodoro',    duration:minToMil(25) };
  }
}

function setTimezoneOffset(elem){
  $(elem).attr("value", (new Date).getTimezoneOffset()/-60);
}

var Polling = new function() {
  var polling;
  var url = [window.location.href, "status.js"].join("/");

  this.start = function() {
    polling = window.setInterval(this.resync, 10000);
  };

  this.resync = function() {
    $.getJSON(url, function(timer) {
      if (! timer.expired) {
        clearInterval(polling);
        window.location.reload();
      }
    });
  };
};

function tickTock(name,year,month,day,hour,minute,second){
  settings = {
    until: new Date(year,month,day,hour,minute,second),
    onExpiry: function(){
      document.title = 'DING!';
      $('p.status').text(name + " completed!");
      $('body').addClass('expired');
      soundManager.play('ding','/sounds/ding.mp3');
      Polling.start();
    },
    onStart: function(){
      document.title = name + ' in progress';
      $('p.status').text(name + ' in progress');
      $('body').removeClass('expired');
    },
    onTick: function(time) {
      document.title = name + ' (' + time[5] + ':' + time[6].toString().lpad('0',2) + ')';
    }
  }
  if($('#timer div').size() == 0) {
    $('#timer').countdown(settings);
  } else {
    $('#timer').countdown('change', settings);
  }
}
