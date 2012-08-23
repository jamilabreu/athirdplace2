jQuery ->
	#$('.user').wookmark()
	$('#users').imagesLoaded () ->
		$('.user').wookmark
			container: $('#users')
			offset: 10
			itemWidth: 192
			autoResize: true
		
	###
	# Isotope
	container = $('#users')
	container.imagesLoaded ->
		container.masonry
			itemSelector: '.user'
			columnWidth: 192
			gutterWidth: 10

		# Infinite Scroll
		if $('.pagination').length
			$(window).scroll ->
				url = $('.pagination .next_page a').attr 'href'
				if url && $(window).scrollTop() > container.height() - 800
					$('.pagination').text 'Fetching more...'
					$.getScript(url)
			$(window).scroll()
	###	
	# Filters
	$('#filters').on 'click', 'ul a', (e) ->
		e.preventDefault()
		#container.masonry 'remove', container.children()
		$('.user').remove()
		$.getScript $(this).attr 'href'

	# Users
	#$('#users').on 'click', 'a', (e) ->
	#	e.preventDefault()
	#	$.getScript $(this).attr 'href'

	# Other
	$('.user_name').hide().fadeIn 1400
	$('.pagination').css 'visibility', 'hidden'