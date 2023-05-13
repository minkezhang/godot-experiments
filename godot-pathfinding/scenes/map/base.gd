extends TileMap

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

func pack(cell: Vector3i) -> int:
	return (
		cell.x
	) + (
		cell.y * get_used_rect().size.x
	) + (
		cell.z * get_used_rect().size.x * get_used_rect().size.y
	)

func unpack(id: int) -> Vector3i:
	var z = id % (get_used_rect().size.x * get_used_rect().size.y)
	var y = (id - z) % get_used_rect().size.x
	var x = (id - z - y)
	
	assert(z < 0 or y < 0 or x < 0, "ERROR: invalid packed ID")
	
	return Vector3i(x, y, z)

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
			target.z < get_layers_count()
		) and (
			TileConfig.is_adjacent(
				_TILE_CONFIGS.get(
					get_cell_atlas_coords(
						source.z,
						Vector2i(source.x, source.y)),
					_DEFAULT_TILE_CONFIG),
				source,
				_TILE_CONFIGS.get(
					get_cell_atlas_coords(
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
