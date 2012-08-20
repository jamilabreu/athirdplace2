jQuery ->
	$('.chzn-select').chosen()
	$('.chzn-select-optional').chosen
		allow_single_deselect: true
	$('#user_bio, #user_profession, #user_company').autosize()

	$('.school-select2').select2
		placeholder: "Select School(s)"
		multiple: true
		minimumInputLength: 3
		ajax:
			url: "http://athirdplace.dev/communities.json"
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
			url: "http://athirdplace.dev/communities.json"
			dataType: 'jsonp'
			data: (term) ->
				cities: term
			results: (data) ->
				results: data
		formatResult: (city) ->
			city.name
		formatSelection: (city) ->
			city.name
	
	#if $('.school-select2').val().length > 2
	$.ajax "http://athirdplace.dev/communities.json?school=true",
		dataType: 'jsonp'
		success: (response) ->
			$('.school-select2').select2 'data', response

	#if $('.city-select2').val().length > 2
	$.ajax "http://athirdplace.dev/communities.json?city=true",
		dataType: 'jsonp'
		success: (response) ->
			$('.city-select2').select2 'data', response