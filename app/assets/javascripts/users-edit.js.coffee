jQuery ->
	$('.chzn-select').chosen()
	$('.chzn-select-optional').chosen
		allow_single_deselect: true
	$('#user_bio, #user_profession, #user_company, #user_blog_url').autosize()

	$('.school-select2').select2
		placeholder: 'Select School(s)'
		multiple: true
		minimumInputLength: 3
		ajax:
			url: '/communities.json'
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
		placeholder: 'Select Current City'
		minimumInputLength: 3
		ajax:
			url: '/communities.json'
			dataType: 'jsonp'
			data: (term) ->
				cities: term
			results: (data) ->
				results: data
		formatResult: (city) ->
			city.name
		formatSelection: (city) ->
			city.name
			
	$('.profession-select2').select2
		placeholder: 'Type or Select a Profession'
		multiple: true
		tokenSeparators: [",", " "]
		ajax:
			url: '/communities.json'
			dataType: 'jsonp'
			data: (term) ->
				professions: term
			results: (data) ->
				results: data
		formatResult: (profession) ->
			profession.name
		formatSelection: (profession) ->
			profession.name

	$('.company-select2').select2
		placeholder: 'Type or Select a Company'
		multiple: true
		ajax:
			url: '/communities.json'
			dataType: 'jsonp'
			data: (term) ->
				companies: term
			results: (data) ->
				results: data
		formatResult: (company) ->
			company.name
		formatSelection: (company) ->
			company.name		

	$.ajax '/communities.json?school=true',
		dataType: 'jsonp'
		success: (response) ->
			if response.length
				$('.school-select2').select2 'data', response

	$.ajax '/communities.json?city=true',
		dataType: 'jsonp'
		success: (response) ->
			if response # Note no length
				$('.city-select2').select2 'data', response
				
	$.ajax '/communities.json?profession=true',
		dataType: 'jsonp'
		success: (response) ->
			if response.length || response.name != "null"
				$('.profession-select2').select2 'data', response
				
	$.ajax '/communities.json?company=true',
		dataType: 'jsonp'
		success: (response) ->
			if response.length
				$('.company-select2').select2 'data', response	