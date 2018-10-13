// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.
$(document).on('page:change', function () {
	$('.flag-trigger').on('click', function () {
		$('.flag-form').toggle();
	})

	$('.submit-flag').on('click', function () {
		$('.flag-success').toggle();
		})

	$('.flag-trigger').tooltip();
})