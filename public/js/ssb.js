$(function(){
  if(window.fluid){
    window.fluid.addDockMenuItem("Pomodoro", function(){
      $('#pomodoro').click();
    });
    window.fluid.addDockMenuItem("Short Break", function(){
      $('#short').click();
    });
    window.fluid.addDockMenuItem("Long Break", function(){
      $('#long').click();
    });
  } else if(window.platform) {
    /* START HACK: the following fixes some odd behavior in prism
     * where it re-inserts menu items over and over again. this
     * works around that undesirable bevhavior*/
    window.platform.icon().menu.removeAllMenuItems();
    // END HACK

    window.platform.icon().menu.addMenuItem('pomo',"Pomdoro", function(){
      $('#pomodoro').click();
    });
    window.platform.icon().menu.addMenuItem('short',"Short Break", function(){
      $('#short').click();
    });
    window.platform.icon().menu.addMenuItem('long',"Long Break", function(){
      $('#long').click();
    });
  }
});

function badge(text) {
  if (window.fluid) {
    window.fluid.dockBadge = text;
  }
}

function modalAlert(description){
  notifications.notify({
    title: "Ding!",
    description: description,
    sticky: true,
    identifier: "ding",
    icon: 'http://tomatoi.st/imgs/tomato_tiny.png'
  });
}
