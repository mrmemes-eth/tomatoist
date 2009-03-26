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

function tickTock(elm){
  settings = {
    until: new Date((new Date).valueOf() + pomo(elm.id).duration),
    onExpiry: function(){
      document.title = 'DING!';
      $('p.status').text(pomo(elm.id).message + " completed!");
      $('body').css('background-color','#C01000');
      soundManager.play('ding','/sounds/ding.mp3');
    },
    onStart: function(){
      document.title = pomo(elm.id).message + ' in progress';
      $('p.status').text(pomo(elm.id).message + ' in progress');
      $('body').css('background-color','#fff');
    }
  }
  if($('#timer div').size() == 0) {
    $('#timer').countdown(settings);
  } else {
    if(document.title != 'DING!'){
      if(!confirm('are you sure you want to change this timer?')) return;
    }
    $('#timer').countdown('change', settings);
  }
}

