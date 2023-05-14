extends Node2D

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$GI.stop()
		for n in $Map/Highlight.get_used_cells(0):
			$Map/Highlight.erase_cell(0, n)
	
	if Input.is_action_just_pressed("ui_accept"):		
		var mpos = get_global_mouse_position()
		var source = $GI.get_waypoint()
		var target = $Map/Base.local_to_map($Map/Base.to_local(mpos))
		$Map/Highlight.set_cell(0, target, 0, Vector2i(2, 0))
	
		var target_z_index = 0
		for i in range($Map/Base.get_layers_count() - 1, -1, -1):
			if $Map/Base.get_cell_source_id(i, target) != -1:
				target_z_index = i
				break
	
		for n in $Map/Highlight.get_used_cells(0):
			$Map/Highlight.erase_cell(0, n)
		
		var path = $Map.astar().get_point_path(
			$Map/Base.pack(source),
			$Map/Base.pack(Vector3i(target.x, target.y, target_z_index)))
		for p in path:
			$Map/Highlight.set_cell(0, Vector2i(p.x, p.y), 0, Vector2i(0, 0))
		$Map/Highlight.set_cell(0, Vector2i(source.x, source.y), 0, Vector2i(1, 0))
		$Map/Highlight.set_cell(0, target, 0, Vector2i(2, 0))
		
		# Cancel any existing movement in the case the unit cannot reach its
		# target.
		if path.is_empty():
			$GI.stop()
		else:
			var waypoints: Array[Vector3i] = []
			for p in path:
				waypoints.append(Vector3i(p))
		
			$GI.set_waypoint(waypoints)
