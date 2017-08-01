// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require underscore
//= require gmaps/google
//= require jquery.turbolinks
//= require bootstrap
//= require turbolinks
//= require_tree .

$(document).ready(function(){
	$('.dropdown-toggle').dropdown();

	$(window).scroll(function(){
		if ($(this).scrollTop() > 70) {
			$('#scrollTop').fadeIn();
		} else {
			$('#scrollTop').fadeOut();
		}
	});

	$('#scrollTop').click(function(){
		$('html, body').animate({scrollTop : 0}, 800);
		return false;
	});


});