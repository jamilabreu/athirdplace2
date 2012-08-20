jQuery ->
	$('.chzn-select').chosen()
	$('.chzn-select-optional').chosen
		allow_single_deselect: true
	$('#user_bio, #user_profession, #user_company, #user_blog_url').autosize()

	$('.school-select2').select2
		placeholder: "Select School(s)"
		multiple: true
		minimumInputLength: 3
		ajax:
			url: "/communities.json"
			dataType: 'jsonp'
			data: (term) ->
				schools: term
			results: (data) ->
				results: data
		formatResult: (school) ->
			school.name
		formatSelection: (school) ->
			school.name	

	$('.city-select2').select2
		placeholder: "Select Current City"
		minimumInputLength: 3
		ajax:
			url: "/communities.json"
			dataType: 'jsonp'
			data: (term) ->
				cities: term
			results: (data) ->
				results: data
		formatResult: (city) ->
			city.name
		formatSelection: (city) ->
			city.name
	
	$.ajax "/communities.json?school=true",
		dataType: 'jsonp'
		success: (response) ->
			$('.school-select2').select2 'data', response

	$.ajax "/communities.json?city=true",
		dataType: 'jsonp'
		success: (response) ->
			$('.city-select2').select2 'data', response