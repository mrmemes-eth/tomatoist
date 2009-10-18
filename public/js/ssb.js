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
  }
});

function modalAlert(description){
  if(window.fluid){
    window.fluid.showGrowlNotification({
      title: "Ding!",
      description: description,
      priority: 2,
      sticky: true,
      identifier: "ding",
      icon: 'http://tomatoi.st/imgs/tomato_tiny.png'
    });
  }
}
