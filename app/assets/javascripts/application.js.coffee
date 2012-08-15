#= require jquery
#= require jquery_ujs

jQuery ->
	#$('.alert').fadeOut(4000)
	$('#settings-toggle').on 'click', (e) ->
		$('#dashboard').slideToggle();
		$('#settings-toggle i').toggleClass('icon-caret-down icon-caret-up')
		$('.dropdown-toggle').toggleClass('active')
		