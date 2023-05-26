extends Node

class_name Map

const _CELL_WIDTH: int = 64
const _CELL_HEIGHT: int = 32
const _CELL_OFFSET: int = 16

enum T {
	TILE_NONE,
	TILE_TERRAIN_GRASS,
	TILE_TERRAIN_WATER,
	TILE_RAMP_GRASS_NORTH,
	TILE_RAMP_GRASS_NORTHEAST,
	TILE_RAMP_GRASS_EAST,
	TILE_RAMP_GRASS_SOUTHEAST,
	TILE_RAMP_GRASS_SOUTH,
	TILE_RAMP_GRASS_SOUTHWEST,
	TILE_RAMP_GRASS_WEST,
	TILE_RAMP_GRASS_NORTHWEST,
	TILE_RAMP_GRASS_NORTHEAST_DOWN,
	TILE_RAMP_GRASS_SOUTHEAST_DOWN,
	TILE_RAMP_GRASS_SOUTHWEST_DOWN,
	TILE_RAMP_GRASS_NORTHWEST_DOWN,
}

class Metadata:
	var _template: TileSet = load("res://classes/map/map.tres")
	var _atlas_lookup: Dictionary = {
		T.TILE_NONE:                      Vector3i(-1, -1, -1),
		T.TILE_TERRAIN_GRASS:             Vector3i(0, 0, 0),
		T.TILE_TERRAIN_WATER:             Vector3i(1, 0, 0),
		T.TILE_RAMP_GRASS_SOUTHEAST:      Vector3i(0, 0, 1),
		T.TILE_RAMP_GRASS_SOUTH:          Vector3i(1, 0, 1),
		T.TILE_RAMP_GRASS_SOUTHWEST:      Vector3i(2, 0, 1),
		T.TILE_RAMP_GRASS_WEST:           Vector3i(3, 0, 1),
		T.TILE_RAMP_GRASS_NORTHWEST:      Vector3i(0, 2, 1),
		T.TILE_RAMP_GRASS_NORTH:          Vector3i(1, 2, 1),
		T.TILE_RAMP_GRASS_NORTHEAST:      Vector3i(2, 2, 1),
		T.TILE_RAMP_GRASS_EAST:           Vector3i(3, 2, 1),
		T.TILE_RAMP_GRASS_SOUTHWEST_DOWN: Vector3i(0, 4, 1),
		T.TILE_RAMP_GRASS_NORTHEAST_DOWN: Vector3i(1, 4, 1),
		T.TILE_RAMP_GRASS_SOUTHEAST_DOWN: Vector3i(2, 4, 1),
		T.TILE_RAMP_GRASS_NORTHWEST_DOWN: Vector3i(3, 4, 1),
	}
	const _INVALID_ATLAS = Vector2i(-1, -1)
	
	func get_atlas(t: T) -> Vector3i:
		return _atlas_lookup.get(t, Vector3i(-1, -1, -1))
	
	func generate_atlas_source(layer: int) -> Array[TileSetAtlasSource]:
		var sources: Array[TileSetAtlasSource]  = []
		for k in range(_template.get_source_count()):
			var source = _template.get_source(_template.get_source_id(k))
			var target = source.duplicate(
				Node.DuplicateFlags.DUPLICATE_USE_INSTANTIATION
			)
			
			var dim = source.get_atlas_grid_size()
			for i in range(dim.x):
				for j in range(dim.y):
					var atlas = source.get_tile_at_coords(Vector2i(i, j))
					if atlas != _INVALID_ATLAS:
						target.get_tile_data(atlas, 0).texture_origin.y = (
							source.get_tile_data(atlas, 0).texture_origin.y + layer * _CELL_OFFSET
						)
					
			target.margins = Vector2i(0, 0)
			sources.append(target)
		return sources

class Tile:
	var _t: T = T.TILE_NONE
	var _position: Vector3i = Vector3i(0, 0, 0)

	func _init(t: T, p: Vector3i):
		_t = t
		_position = p

var _tiles: Array[Tile] = []
var _metadata: Metadata = Metadata.new()
var _n_layers: int = 0

var map: Node2D = Node2D.new()

func _init(tiles: Array[Tile]):
	_tiles = tiles
	for t in _tiles:
		_n_layers = max(_n_layers, t._position.z + 1)
	
	# Initialize the isometric tilemap properties.
	var terrain: TileMap = TileMap.new()
	terrain.set_name("Terrain")
	terrain.tile_set = TileSet.new()
	terrain.tile_set.tile_shape = TileSet.TILE_SHAPE_ISOMETRIC
	terrain.tile_set.tile_layout = TileSet.TILE_LAYOUT_DIAMOND_DOWN
	terrain.tile_set.tile_size = Vector2i(64, 32)
	terrain.y_sort_enabled = true
	
	for i in range(_n_layers):
		for s in _metadata.generate_atlas_source(i - 1):
			terrain.tile_set.add_source(s)
	
	map.add_child(terrain)
	
	for t in _tiles:
		add_tile(t._position, t._t)

func add_tile(p: Vector3i, t: T):
	var atlas = _metadata.get_atlas(t)
	map.get_node("Terrain").set_cell(
		0,                                                       # layer
		Vector2i(p.x, p.y),                                      # coords
		p.z * _metadata._template.get_source_count() + atlas.z,  # source
		Vector2i(atlas.x, atlas.y),                              # atlas
	)
