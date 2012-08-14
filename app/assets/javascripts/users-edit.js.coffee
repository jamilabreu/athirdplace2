jQuery ->
	$('.chzn-select').chosen()
	$('.chzn-select-optional').chosen({allow_single_deselect: true})
	$('#user_bio, #user_company').autosize()	