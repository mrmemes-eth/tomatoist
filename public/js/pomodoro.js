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
  var running_message = pomo(elm.id).message + ' in progress';
  document.title = running_message;
  $('p.status').text(running_message);
  $('#countdown').countdown({
    until: new Date((new Date).valueOf() + pomo(elm.id).duration),
    onExpiry: function(){
      $('p.status').text(pomo(elm.id).message + " completed!");
      $('body').css('background','#C01000');
      document.title = 'DING!';
    },
    alwaysExpire: true,
    format: 'MS'
  });
}

