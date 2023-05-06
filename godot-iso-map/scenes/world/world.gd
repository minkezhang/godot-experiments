extends Node2D

var _tile_groups = [
	[
		Vector3i(5, -4, 1),
		Vector3i(6, -4, 1),
		Vector3i(5, -3, 1),
		Vector3i(6, -3, 1),
		Vector3i(5, -4, 2),
		Vector3i(6, -4, 2),
		Vector3i(5, -3, 2),
		Vector3i(6, -3, 2),
	]
]

var _tile_groups_lookup = {
	Vector3i(5, -4, 1): _tile_groups[0],
	Vector3i(6, -4, 1): _tile_groups[0],
	Vector3i(5, -3, 1): _tile_groups[0],
	Vector3i(6, -3, 1): _tile_groups[0],
	Vector3i(5, -4, 2): _tile_groups[0],
	Vector3i(6, -4, 2): _tile_groups[0],
	Vector3i(5, -3, 2): _tile_groups[0],
	Vector3i(6, -3, 2): _tile_groups[0],
}

func _process(_delta):
	var mpos = get_global_mouse_position()
	var tile = $Map.select_tile($Map/Render.to_local(mpos))
	
	var group = _tile_groups_lookup.get(tile, [tile])
	$Map.highlight_tiles(group)
