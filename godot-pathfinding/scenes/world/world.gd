extends Node2D

var _NULL_POS = Vector2i(-1, -1)

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		$Map/GI.cancel_path()
		for n in $Map/Highlight.get_used_cells(0):
			$Map/Highlight.erase_cell(0, n)
	
	if Input.is_action_just_pressed("ui_accept"):
		var mpos = get_global_mouse_position()
		var source = $Map/Base.local_to_map($Map/Base.to_local($Map/GI.position))
		var target = $Map/Base.local_to_map($Map/Base.to_local(mpos))
		$Map/Highlight.set_cell(0, target, 0, Vector2i(2, 0))
	
		for n in $Map/Highlight.get_used_cells(0):
			$Map/Highlight.erase_cell(0, n)
		var path = $Map.astar().get_point_path(
			$Map.pack(Vector3i(source.x, source.y, 0)),
			$Map.pack(Vector3i(target.x, target.y, 0)))
		for n in path:
			$Map/Highlight.set_cell(0, Vector2i(n.x, n.y), 0, Vector2i(0, 0))
		$Map/Highlight.set_cell(0, source, 0, Vector2i(1, 0))
		$Map/Highlight.set_cell(0, target, 0, Vector2i(2, 0))
		
		var _path = []
		for p in path:
			_path.append_array(
				[Vector3i(
					$Map/Base.map_to_local(Vector2i(p.x, p.y)).x,
					$Map/Base.map_to_local(Vector2i(p.x, p.y)).y,
					p.z,
				)]
			)
		$Map/GI.set_path(_path)
