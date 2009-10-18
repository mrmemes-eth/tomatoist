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

