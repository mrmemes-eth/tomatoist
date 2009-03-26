$.countdown.setDefaults({alwaysExpire: true, format: 'MS'})

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

function setRunningMessage(period){
  var msg = pomo(period).message + ' in progress';
  document.title = msg;
  $('p.status').text(msg);
}

function tickTock(elm){
  setRunningMessage(elm.id);
  settings = {
    until: new Date((new Date).valueOf() + pomo(elm.id).duration),
    onExpiry: function(){
      $('p.status').text(pomo(elm.id).message + " completed!");
      $('body').css('background','#C01000');
      document.title = 'DING!';
    }
  }
  if($('#timer div').size() == 0) {
    $('#timer').countdown(settings);
  } else {
    if(!confirm('are you sure you want to change this timer?')) return;
    $('body').css('background','#fff');
    $('#timer').countdown('change', settings);
  }
}

