$.countdown.setDefaults({alwaysExpire: true, format: 'MS'})
soundManager.url = 'swf/'

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

function tickTock(name,year,month,day,hour,minute,second){
  settings = {
    until: new Date(year,month,day,hour,minute,second),
    onExpiry: function(){
      document.title = 'DING!';
      $('p.status').text(name + " completed!");
      $('body').addClass('expired');
      soundManager.play('ding','/sounds/ding.mp3');
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

