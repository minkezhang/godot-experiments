extends Node2D


func _process(_delta):
	## DEBUG
	if Input.is_action_just_pressed("ui_select"):
		var mpos = get_global_mouse_position()
		var local = $Map/Render.to_local(mpos)
		var apparent = $Map/Render.local_to_map(local)
		var apparent_neighbors = $Map._get_neighbors_apparent(local)
		print("DEBUG(world): Candidates for apparent = %s: %s" % [apparent, apparent_neighbors])
		print("DEBUG(world): raytrace stack: %s" % [$Map._get_rendered_stack(apparent_neighbors)])
	
	var mpos = get_global_mouse_position()
	var cell = $Map.select_cell($Map/Render.to_local(mpos))
		
	$Map/Highlight.set_highlights([cell], $Map/Highlight.SELECT)
