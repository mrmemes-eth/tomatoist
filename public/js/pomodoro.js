soundManager.url = 'swf/';
soundManager.debugMode = false;

String.prototype.lpad = function(padString, length) {
  var str = this;
  while (str.length < length)
    str = padString + str;
  return str;
}

$(function(){
  $('a[rel*=facebox]').facebox();

  $("#twitter").getTwitter({
    userName: "tomatoist",
    numTweets: 3,
    loaderText: "Loading tweets...",
    slideIn: false,
    showHeading: true,
    headingText: "News",
    showProfileLink: false
  });
});

function audibleAlert(){
  if(window.fluid){
    window.fluid.playSoundNamed("Glass");
  } else {
    soundManager.onready(function(){
      soundManager.play('ding', '/sounds/ding.mp3');
    });
  }
}

function tickTock(name,localTime,expiryTime){
  $('#timer').countdown({
    format: 'MS',
    compact: true,
    until: new Date(Date.parse(expiryTime)),
    onExpiry: function(){
      document.title = 'DING!';
      modalAlert(name + ' completed!');
      audibleAlert();
      Polling.start();
      $('p.status').text(name + ' completed!');
      $('body').addClass('expired');
    },
    serverTime: new Date(Date.parse(localTime)),
    onTick: function(time) {
      document.title = name + ' (' + time[5] + ':' + time[6].toString().lpad('0',2) + ')';
    }
  });
}
