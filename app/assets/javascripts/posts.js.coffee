jQuery ->
	###
	# Filters
	$('#filters').on 'click', 'ul li a', (e) ->
		e.preventDefault()
		$.getScript $(this).attr 'href'
	###