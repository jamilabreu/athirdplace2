jQuery ->
	$('.jumbotron').hide().delay(800).slideDown(800)
	$('#opaque').hide().fadeIn(2000)

	# Activity Indicator on Signin
	$('#sign_in').click ->
		$('#sign_in').html("<i class='icon-facebook-sign'></i> Signing In...<div class='activity-indicator hidden-phone'></div>")
		$('.activity-indicator').activity(
			segments: 8
			width: 2
			space: 0
			length: 2
			speed: 1.1
		)