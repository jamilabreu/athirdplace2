jQuery ->
	container = $("#users")
	# Isotope
	container = $('#users')
	container.imagesLoaded ->
		container.isotope
			itemSelector: '.user'

		# Infinite Scroll
		if $('.pagination').length
			$(window).scroll ->
				url = $('.pagination .next_page a').attr 'href'
				if url && $(window).scrollTop() > container.height() - 850
					$('.pagination').text 'Fetching more...'
					$.getScript(url)
			$(window).scroll()	
			
	# Filters
	$('#filters').on 'click', 'ul li a', (e) ->
		e.preventDefault()
		container.isotope 'remove', container.children()
		$.getScript $(this).attr 'href'

	# Other
	$('.user_name').hide().fadeIn 1400
	$('.pagination').css 'visibility', 'hidden'