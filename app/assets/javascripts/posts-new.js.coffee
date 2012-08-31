jQuery ->
	$('.chzn-select').chosen
		allow_single_deselect: true
	$('#post_input, #post_title, #post_body').autosize()
	
	$('#post_input').bind 'input paste propertychange', ->
		input = $.trim($(this).val())
		if !input.length
			$('#post_body').val('')
			$('#preview_post').hide()
		else
			if $('#preview_post').is(":hidden")
				$('.post-activity-indicator').show().activity
					segments: 8
					width: 2
					space: 0
					length: 2
					speed: 1.1	
			$.ajax
				type: "POST"
				url: '/posts/new/preview'
				data: { q : input }

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
