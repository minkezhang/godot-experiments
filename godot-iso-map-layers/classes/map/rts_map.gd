extends Resource

# Create the TileMap scene which renders the isometric terrain, cliffs, and
# bridges.
class_name RTSMap

var _rts_map: Node2D = Node2D.new()

const _CELL_WIDTH: int = 64
const _CELL_HEIGHT: int = 32
const _CELL_OFFSET: int = 16
const _INVALID_ATLAS_COORD = Vector2i(-1, -1)

var _tile_config: TileConfig = TileConfig.new()

func generate_render_atlas_sources(layer: int) -> Array[TileSetSource]:
		var sources: Array[TileSetSource]  = []
		for k in range(_tile_config.RENDER_TILESET.get_source_count()):
			var source = _tile_config.RENDER_TILESET.get_source(_tile_config.RENDER_TILESET.get_source_id(k))
			var target = source.duplicate(
				Node.DuplicateFlags.DUPLICATE_USE_INSTANTIATION
			)
			
			if source is TileSetAtlasSource:
				var dim = source.get_atlas_grid_size()
				for i in range(dim.x):
					for j in range(dim.y):
						var atlas = source.get_tile_at_coords(Vector2i(i, j))
						if atlas != _INVALID_ATLAS_COORD:
							target.get_tile_data(atlas, 0).texture_origin.y = (
								source.get_tile_data(atlas, 0).texture_origin.y + layer * _CELL_OFFSET
							)
					
				target.margins = Vector2i(0, 0)
			elif source is TileSetScenesCollectionSource:
				pass
			sources.append(target)
		return sources

func _init(tiles: Array[Tile], n_layers: int = 1):
	_rts_map.set_name("RTSMap")
	
	# Initialize the isometric tilemap properties.
	var terrain: TileMap = TileMap.new()
	terrain.set_name("Terrain")
	terrain.tile_set = TileSet.new()
	terrain.tile_set.tile_shape = TileSet.TILE_SHAPE_ISOMETRIC
	terrain.tile_set.tile_layout = TileSet.TILE_LAYOUT_DIAMOND_DOWN
	terrain.tile_set.tile_size = Vector2i(64, 32)
	terrain.y_sort_enabled = true
	
	for i in range(n_layers):
		for s in generate_render_atlas_sources(i - 1):
			terrain.tile_set.add_source(s)
	
	_rts_map.add_child(terrain)
	
	for t in tiles:
		add_tile(t._position, t._t)

func add_tile(p: Vector3i, t: TileConfig.T):
	var atlas = _tile_config.get_by_tile(t).get_render_atlas_coord()
	_rts_map.get_node("Terrain").set_cell(
		0,                                                               # layer
		Vector2i(p.x, p.y),                                              # coords
		p.z * _tile_config.RENDER_TILESET.get_source_count() + atlas.z,  # source
		Vector2i(atlas.x, atlas.y),                                      # atlas
	)

func get_rts_map() -> Node2D:
	return _rts_map
