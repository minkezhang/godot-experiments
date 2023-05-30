extends Resource

class_name TileConfig

var RENDER_TILESET: TileSet = load("res://assets/map/render.tres")
var SCHEMATIC_TILESET: TileSet = load("res://assets/map/schematic.tres")

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
	TILE_CLIFF_NORTH,
	TILE_CLIFF_NORTHEAST,
	TILE_CLIFF_EAST,
	TILE_CLIFF_SOUTHEAST,
	TILE_CLIFF_SOUTH,
	TILE_CLIFF_SOUTHWEST,
	TILE_CLIFF_WEST,
	TILE_CLIFF_NORTHWEST,
}

const _INVALID_ATLAS_COORD: Vector3i = Vector3i(-1, -1, -1)
var _configs: Array[TileConfigInstance] = [
	TileConfigInstance.new(
		T.TILE_NONE,
		_INVALID_ATLAS_COORD,  # render atlas coord
		_INVALID_ATLAS_COORD,  # schematic atlas coord
	),
	TileConfigInstance.new(
		T.TILE_TERRAIN_GRASS,
		Vector3i(0, 0, 0),
		Vector3i(0, 0, 0),
	),            
	TileConfigInstance.new(
		T.TILE_TERRAIN_WATER,
		Vector3i(1, 0, 0),
		Vector3i(1, 0, 0),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_SOUTHEAST,
		Vector3i(0, 0, 1),
		Vector3i(0, 0, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_SOUTH,
		Vector3i(1, 0, 1),
		Vector3i(1, 0, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_SOUTHWEST,
		Vector3i(2, 0, 1),
		Vector3i(2, 0, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_WEST,
		Vector3i(3, 0, 1),
		Vector3i(3, 0, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_NORTHWEST,
		Vector3i(0, 2, 1),
		Vector3i(0, 1, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_NORTH,
		Vector3i(1, 2, 1),
		Vector3i(1, 1, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_NORTHEAST,
		Vector3i(2, 2, 1),
		Vector3i(2, 1, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_EAST,
		Vector3i(3, 2, 1),
		Vector3i(3, 1, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_SOUTHWEST_DOWN,
		Vector3i(0, 4, 1),
		Vector3i(0, 2, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_NORTHEAST_DOWN,
		Vector3i(1, 4, 1),
		Vector3i(1, 2, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_SOUTHEAST_DOWN,
		Vector3i(2, 4, 1),
		Vector3i(2, 2, 1),
	),
	TileConfigInstance.new(
		T.TILE_RAMP_GRASS_NORTHWEST_DOWN,
		Vector3i(3, 4, 1),
		Vector3i(3, 2, 1),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_SOUTHEAST,
		Vector3i(0, 0, 2),
		Vector3i(0, 0, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_SOUTH,
		Vector3i(1, 0, 2),
		Vector3i(2, 0, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_SOUTHWEST,
		Vector3i(3, 0, 2),
		Vector3i(4, 0, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_WEST,
		Vector3i(4, 0, 2),
		Vector3i(6, 0, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_NORTHWEST,
		Vector3i(0, 4, 2),
		Vector3i(0, 2, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_NORTH,
		Vector3i(1, 4, 2),
		Vector3i(2, 2, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_NORTHEAST,
		Vector3i(3, 4, 2),
		Vector3i(4, 2, 2),
	),
	TileConfigInstance.new(
		T.TILE_CLIFF_EAST,
		Vector3i(4, 4, 2),
		Vector3i(6, 2, 2),
	),
]

## Tile information config.
##
## Instances must only be constructed and changed inside this file.
class TileConfigInstance:
	var _tile: T = T.TILE_NONE
	var _render_atlas_coord: Vector3i = _INVALID_ATLAS_COORD
	var _schematic_atlas_coord: Vector3i = _INVALID_ATLAS_COORD

	func _init(tile: T, render: Vector3i, schematic: Vector3i):
		_tile = tile
		_render_atlas_coord = render
		_schematic_atlas_coord = schematic
	
	func get_tile() -> T:
		return _tile
	
	func get_render_atlas_coord() -> Vector3i:
		return _render_atlas_coord
	
	func get_schematic_atlas_coord() -> Vector3i:
		return _schematic_atlas_coord

var _lookup_tile: Dictionary
var _lookup_render: Dictionary
var _lookup_schematic: Dictionary

func _init():
	for c in _configs:
		_lookup_tile[c._tile] = c
		_lookup_render[c._render_atlas_coord] = c
		_lookup_schematic[c._schematic_atlas_coord] = c

func get_by_tile(t: T) -> TileConfigInstance:
	return _lookup_tile.get(t, _lookup_tile[T.TILE_NONE])

func get_by_render(atlas: Vector3i) -> TileConfigInstance:
	return _lookup_render.get(atlas, _lookup_tile[T.TILE_NONE])

func get_by_schematic(atlas: Vector3i) -> TileConfigInstance:
	return _lookup_schematic.get(atlas, _lookup_tile[T.TILE_NONE])
