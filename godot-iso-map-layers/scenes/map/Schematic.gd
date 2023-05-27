extends TileMap

var _tile_config = TileConfig.new()

var n_elevation_layers: int = 1
var elevation: Dictionary = {
	Vector2i(5, 3): 1,
	Vector2i(5, 4): 1,
	Vector2i(5, 5): 1,
	Vector2i(6, 3): 1,
	Vector2i(6, 4): 2,
	Vector2i(6, 5): 1,
	Vector2i(7, 3): 1,
	Vector2i(7, 4): 1,
	Vector2i(7, 5): 1,
}

enum _SchematicLayer {
	_SCHEMATIC_LAYER_TERRAIN,
	_SCHEMATIC_LAYER_BRIDGE,
}

func _ready():
	for i in get_layers_count():
		for t in get_used_cells(i):
			n_elevation_layers = max(n_elevation_layers, elevation.get(t, 0) + 1)

func get_tiles() -> Array[Tile]:
	var tiles: Array[Tile] = []
	for i in get_layers_count():
		for t in get_used_cells(i):
			var atlas = get_cell_atlas_coords(i, t)
			var config = _tile_config.get_by_schematic(
				Vector3i(atlas.x, atlas.y, get_cell_source_id(i, t)))
			tiles.append(Tile.new(
				config.get_tile(), Vector3i(t.x, t.y, elevation.get(t, 0)),
			))
	return tiles

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
