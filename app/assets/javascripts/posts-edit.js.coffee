jQuery ->
	$('.chzn-select').chosen
		allow_single_deselect: true
	$('#post_title, #post_body, #link_title, #link_body, #event_title, #event_start_time, #event_body').autosize()

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
		placeholder: 'Select City'
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
		minimumInputLength: 3
		multiple: true
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