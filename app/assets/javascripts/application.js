// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery-tablesorter
//= require jquery_ujs
//= require popper
//= require turbolinks
//= require bootstrap
//= require clipboard
//= require bootstrap-select
//= require activestorage
//= require_tree .

var alertTimeout;
var ready = function(){
  // Clear previous timer in case page is loaded with turbolinks
  if(alertTimeout != null){
    clearTimeout(alertTimeout);
  }
  alertTimeout = setTimeout(function() {
    $('.alert-container').slideUp();
  }, 3000);
};

document.addEventListener('turbolinks:load', ready);
