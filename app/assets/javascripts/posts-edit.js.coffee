jQuery ->
	$('.chzn-select').chosen
		allow_single_deselect: true
	$('#post_title, #post_body, #link_title, #link_body, #event_title, #event_start_time, #event_body').autosize()
	