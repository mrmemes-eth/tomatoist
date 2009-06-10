$.countdown.setDefaults({alwaysExpire: true, format: 'MS'})
soundManager.url = 'swf/'

var isCtrl = false;

$(document).keyup(function(e){
  if(e.which == 18) isOpt = false;
});

$(document).keydown(function(e){
  // console.log(e.type,"keyCode:"+e.keyCode,"which:"+e.which,"charCode:"+String.fromCharCode(e.which));
  if(e.which == 18) isOpt = true;
  if(isOpt){
    if($.inArray(e.keyCode, [80,83,76]) > -1){
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
    }
  }
  if($('#timer div').size() == 0) {
    $('#timer').countdown(settings);
  } else {
    $('#timer').countdown('change', settings);
  }
}

