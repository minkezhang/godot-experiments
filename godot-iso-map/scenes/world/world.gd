extends Node2D


func _process(_delta):
	var mpos = get_global_mouse_position()
	var tile = $Map.select_tile($Map/Render.to_local(mpos))

	var tiles : Array[Vector3i] = [tile]
	$Map.highlight_tiles(tiles)
