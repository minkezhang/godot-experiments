extends Node2D

var _DEFAULT_TILE_CONFIG = TileConfig.new()
var _TILE_CONFIGS = {
	Vector2i(0, 0): TileConfig.new(Vector2i(0, 0)),
	Vector2i(1, 0): TileConfig.new(Vector2i(1, 0)),
	Vector2i(2, 0): TileConfig.new(
		Vector2i(2, 0),
		[
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST_UP,
			
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_CENTER,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST,
		],
	),
	Vector2i(3, 0): TileConfig.new(
		Vector2i(3, 0),
		[
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_UP,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST_UP,
			
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_CENTER,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH,
			TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST,
		],
	),
	Vector2i(4, 0): TileConfig.new(Vector2i(4, 0)),
}

var _astar: AStar3D

var _dim: Vector3i

func astar() -> AStar3D:
	return _astar

func pack(v: Vector3i) -> int:
	return v.x + v.y * _dim.x + v.z * _dim.x * _dim.y

func unpack(id: int, dim: Vector3i) -> Vector3i:
	var z = id % (dim.x * dim.y)
	var y = (id - z) % dim.x
	var x = (id - z - y)
	if z < 0 or y < 0 or x < 0:
		return Vector3i(-1, -1, -1)
	return Vector3i(x, y, z)	
	
func _ready():
	_dim = Vector3i(
		$Base.get_used_rect().size.x,
		$Base.get_used_rect().size.y,
		$Base.get_layers_count(),
	)
	
	_astar = AStar3D.new()
	_astar.reserve_space(_dim.x * _dim.y * _dim.z)
	for i in range($Base.get_layers_count()):
		for n in $Base.get_used_cells(i):
			_astar.add_point(
				pack(Vector3i(n.x, n.y, i)),
				Vector3i(n.x, n.y, i))
	
	for i in range ($Base.get_layers_count()):
		for n in $Base.get_used_cells(i):
			var source = Vector3i(n.x, n.y, i)
			for target in get_adjacent_tiles(source):
				_astar.connect_points(pack(source), pack(target))

func get_adjacent_tiles(source: Vector3i) -> Array:
	var adjacent_tiles = {}
	for e in TileConfig.NEIGHBOR_OFFSETS:
		var offset = TileConfig.NEIGHBOR_OFFSETS[e]
		var target = source + offset
		if (
			e != TileConfig.CellNeighbor.CELL_NEIGHBOR_CENTER
		) and (
			0 <= target.z
		) and (
			target.z < $Base.get_layers_count()
		) and (
			TileConfig.is_adjacent(
				_TILE_CONFIGS.get(
					$Base.get_cell_atlas_coords(
						source.z,
						Vector2i(source.x, source.y)),
					_DEFAULT_TILE_CONFIG),
				source,
				_TILE_CONFIGS.get(
					$Base.get_cell_atlas_coords(
						target.z,
						Vector2i(target.x, target.y)),
					_DEFAULT_TILE_CONFIG),
				target)):
			adjacent_tiles[e] = target
	
	# Emulate AStarGrid2D.DiagonalMode.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES
	# behavior for cells within the same layer. Diagonal movement is allowed for
	# the z-index, as this is how we fake traveling up ramps.
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_UP,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST_UP]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST_UP)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_UP,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST_UP]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST_UP)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_UP,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST_UP]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST_UP)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_UP,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST_UP]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST_UP)
	
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST)
	
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_DOWN,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST_DOWN]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_WEST_DOWN)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_DOWN,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST_DOWN]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_NORTH_EAST_DOWN)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_DOWN,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_WEST_DOWN]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST_DOWN)
	if not adjacent_tiles.has_all([
		TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_DOWN,
		TileConfig.CellNeighbor.CELL_NEIGHBOR_EAST_DOWN]):
			adjacent_tiles.erase(TileConfig.CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST_DOWN)
	
	return adjacent_tiles.values()
