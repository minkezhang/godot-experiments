extends Node2D


func _process(_delta):
	var mpos = get_global_mouse_position()
	var cell = $Map.select_cell($Map/Render.to_local(mpos))

	var cells : Array[Vector3i] = [cell]
	$Map.highlight_cells(cells, $Map/Highlight.SELECT)
