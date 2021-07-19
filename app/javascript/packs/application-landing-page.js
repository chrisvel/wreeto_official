/* eslint no-console:0 */
// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.
//
// To reference this file, add <%= javascript_pack_tag 'application' %> to the appropriate
// layout file, like app/views/layouts/application.html.erb


// Uncomment to copy all static images under ../images to the output folder and reference
// them with the image_pack_tag helper in views (e.g <%= image_pack_tag 'rails.png' %>)
// or the `imagePath` JavaScript helper below.
//
// const images = require.context('../images', true)
// const imagePath = (name) => images(name, true)

// require("@rails/ujs").start();
// require("turbolinks").start();
// require("@rails/activestorage").start();
// require("@rails/actioncable").start();

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

require('select2')
require('clipboard')
require('bootstrap-select')

import 'jquery'
import 'popper.js'
import 'bootstrap'
import 'bootstrap-select'
import "@fortawesome/fontawesome-free/css/all"
import 'select2'
import 'select2/dist/css/select2.css'
import 'clipboard'
import CodeMirror from "codemirror";
import EasyMDE from "easymde";
import "easymde/dist/easymde.min.css";

// stylesheets
import "../stylesheets/landing_page/application-landing-page";
import "../stylesheets/landing_page/pages";
import 'bootstrap-select/dist/css/bootstrap-select.css';

// other JS
import '../src/pages.js';

Rails.start()
Turbolinks.start()
ActiveStorage.start()

require.context('../images', true);

$(function () {
  // console.log('Hello World from Webpacker');
});

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