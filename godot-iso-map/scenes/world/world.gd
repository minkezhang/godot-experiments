extends Node2D


func _process(_delta):
	var mpos = get_global_mouse_position()
	var cell = $Map.select_cell($Map/Render.to_local(mpos))
		
	$Map/Highlight.set_highlights([cell], $Map/Highlight.SELECT)
