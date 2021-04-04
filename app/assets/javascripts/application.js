// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require bootstrap-sprockets
//= require Chart.min
//= require rails-ujs
//= require activestorage
//= require_tree .
//= require dropzone
//= require chartkick
//= require Chart.bundle

jQuery(function ($) {
  //data-hrefの属性を持つtrを選択しclassにclickableを付加
  $("tr[data-href]")
    .addClass("clickable")

  //クリックイベント
  .click(function (e) {
    //e.targetはクリックした要素自体、それがa要素以外であれば
    if (!$(e.target).is("a")) {
      //その要素の先祖要素で一番近いtrの
      //data-href属性の値に書かれているURLに遷移する
      window.location = $(e.target).closest("tr").data("href");
    }
  });
});

jQuery(function ($) {
  //data-hrefの属性を持つtrを選択しclassにclickableを付加
  $("div[data-href]")
    .addClass("clickable")

  //クリックイベント
  .click(function (e) {
    //e.targetはクリックした要素自体、それがa要素以外であれば
    if (!$(e.target).is("a")) {
      //その要素の先祖要素で一番近いtrの
      //data-href属性の値に書かれているURLに遷移する
      window.location = $(e.target).closest("div").data("href");
    }
  });
});

$(function(){
  setTimeout("$('.time-limit').fadeOut('slow')", 3000) 
})
