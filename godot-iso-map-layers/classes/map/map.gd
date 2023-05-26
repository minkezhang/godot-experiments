extends Node

class_name Map

const _CELL_WIDTH: int = 64
const _CELL_HEIGHT: int = 32
const _CELL_OFFSET: int = 16

enum T {
	TILE_NONE,
	TILE_GRASS,
	TILE_WATER,
	TILE_RAMP_NORTH,
	TILE_RAMP_NORTHEAST,
	TILE_RAMP_EAST,
	TILE_RAMP_SOUTHEAST,
	TILE_RAMP_SOUTH,
	TILE_RAMP_SOUTHWEST,
	TILE_RAMP_WEST,
	TILE_RAMP_NORTHWEST,
	TILE_RAMP_NORTHEAST_DOWN,
	TILE_RAMP_SOUTHEAST_DOWN,
	TILE_RAMP_SOUTHWEST_DOWN,
	TILE_RAMP_NORTHWEST_DOWN,
}

class Metadata:
	var _template: TileSet = load("res://classes/map/map.tres")
	var _atlas_lookup: Dictionary = {
		T.TILE_NONE:                Vector3i(-1, -1, -1),
		T.TILE_GRASS:               Vector3i(0, 0, 0),
		T.TILE_WATER:               Vector3i(1, 0, 0),
		T.TILE_RAMP_NORTH:          Vector3i(0, 0, 1),
		T.TILE_RAMP_NORTHEAST:      Vector3i(1, 0, 1),
		T.TILE_RAMP_EAST:           Vector3i(2, 0, 1),
		T.TILE_RAMP_SOUTHEAST:      Vector3i(3, 0, 1),
		T.TILE_RAMP_SOUTH:          Vector3i(0, 2, 1),
		T.TILE_RAMP_SOUTHWEST:      Vector3i(1, 2, 1),
		T.TILE_RAMP_WEST:           Vector3i(2, 2, 1),
		T.TILE_RAMP_NORTHWEST:      Vector3i(3, 2, 1),
		T.TILE_RAMP_NORTHEAST_DOWN: Vector3i(0, 4, 1),
		T.TILE_RAMP_SOUTHEAST_DOWN: Vector3i(1, 4, 1),
		T.TILE_RAMP_SOUTHWEST_DOWN: Vector3i(2, 4, 1),
		T.TILE_RAMP_NORTHWEST_DOWN: Vector3i(3, 4, 1),
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
						target.get_tile_data(atlas, 0).texture_origin.y -= layer * _CELL_OFFSET
					
			target.margins = Vector2i(1, 1)
			sources.append(target)
		return sources

class Tile:
	var _t: T = T.TILE_NONE
	var _position: Vector3i = Vector3i(0, 0, 0)

	func _init(p: Vector3i, t: T):
		_t = t
		_position = p

var _tiles: Array[Tile] = []

# TODO(minkezhang): Move to external world script.
var m: Array[Tile] = [
	Tile.new(Vector3i(0, 0, 0), T.TILE_GRASS),
]

func _init(tiles: Array[Tile]):
	_tiles = tiles
