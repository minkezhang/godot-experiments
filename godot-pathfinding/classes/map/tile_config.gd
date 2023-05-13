class_name TileConfig

const _INVALID_VECTOR2D = Vector2i(-1, -1)
const _INVALID_VECTOR3D = Vector3i(-1, -1, -1)

enum CellNeighbor {
	CELL_NEIGHBOR_INVALID,
	
	CELL_NEIGHBOR_NORTH_WEST_UP,
	CELL_NEIGHBOR_NORTH_UP,
	CELL_NEIGHBOR_NORTH_EAST_UP,
	CELL_NEIGHBOR_WEST_UP,
	CELL_NEIGHBOR_CENTER_UP,
	CELL_NEIGHBOR_EAST_UP,
	CELL_NEIGHBOR_SOUTH_WEST_UP,
	CELL_NEIGHBOR_SOUTH_UP,
	CELL_NEIGHBOR_SOUTH_EAST_UP,
	
	CELL_NEIGHBOR_NORTH_WEST,
	CELL_NEIGHBOR_NORTH,
	CELL_NEIGHBOR_NORTH_EAST,
	CELL_NEIGHBOR_WEST,
	CELL_NEIGHBOR_CENTER,
	CELL_NEIGHBOR_EAST,
	CELL_NEIGHBOR_SOUTH_WEST,
	CELL_NEIGHBOR_SOUTH,
	CELL_NEIGHBOR_SOUTH_EAST,
	
	CELL_NEIGHBOR_NORTH_WEST_DOWN,
	CELL_NEIGHBOR_NORTH_DOWN,
	CELL_NEIGHBOR_NORTH_EAST_DOWN,
	CELL_NEIGHBOR_WEST_DOWN,
	CELL_NEIGHBOR_CENTER_DOWN,
	CELL_NEIGHBOR_EAST_DOWN,
	CELL_NEIGHBOR_SOUTH_WEST_DOWN,
	CELL_NEIGHBOR_SOUTH_DOWN,
	CELL_NEIGHBOR_SOUTH_EAST_DOWN,
}

# _ADJACENCY_DELTA added to the cell coordinate gives the corresponding
# neighboring cell.
const _ADJACENCY_DELTA = {
	Vector3i(-1, -1,  1): CellNeighbor.CELL_NEIGHBOR_NORTH_WEST_UP,
	Vector3i( 0, -1,  1): CellNeighbor.CELL_NEIGHBOR_NORTH_UP,
	Vector3i( 1, -1,  1): CellNeighbor.CELL_NEIGHBOR_NORTH_EAST_UP,
	Vector3i(-1,  0,  1): CellNeighbor.CELL_NEIGHBOR_WEST_UP,
	Vector3i( 0,  0,  1): CellNeighbor.CELL_NEIGHBOR_CENTER_UP,
	Vector3i( 1,  0,  1): CellNeighbor.CELL_NEIGHBOR_EAST_UP,
	Vector3i(-1,  1,  1): CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST_UP,
	Vector3i( 0,  1,  1): CellNeighbor.CELL_NEIGHBOR_SOUTH_UP,
	Vector3i( 1,  1,  1): CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST_UP,
	
	Vector3i(-1, -1,  0): CellNeighbor.CELL_NEIGHBOR_NORTH_WEST,
	Vector3i( 0, -1,  0): CellNeighbor.CELL_NEIGHBOR_NORTH,
	Vector3i( 1, -1,  0): CellNeighbor.CELL_NEIGHBOR_NORTH_EAST,
	Vector3i(-1,  0,  0): CellNeighbor.CELL_NEIGHBOR_WEST,
	Vector3i( 0,  0,  0): CellNeighbor.CELL_NEIGHBOR_CENTER,
	Vector3i( 1,  0,  0): CellNeighbor.CELL_NEIGHBOR_EAST,
	Vector3i(-1,  1,  0): CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST,
	Vector3i( 0,  1,  0): CellNeighbor.CELL_NEIGHBOR_SOUTH,
	Vector3i( 1,  1,  0): CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST,
	
	Vector3i(-1, -1, -1): CellNeighbor.CELL_NEIGHBOR_NORTH_WEST_DOWN,
	Vector3i( 0, -1, -1): CellNeighbor.CELL_NEIGHBOR_NORTH_DOWN,
	Vector3i( 1, -1, -1): CellNeighbor.CELL_NEIGHBOR_NORTH_EAST_DOWN,
	Vector3i(-1,  0, -1): CellNeighbor.CELL_NEIGHBOR_WEST_DOWN,
	Vector3i( 0,  0, -1): CellNeighbor.CELL_NEIGHBOR_CENTER_DOWN,
	Vector3i( 1,  0, -1): CellNeighbor.CELL_NEIGHBOR_EAST_DOWN,
	Vector3i(-1,  1, -1): CellNeighbor.CELL_NEIGHBOR_SOUTH_WEST_DOWN,
	Vector3i( 0,  1, -1): CellNeighbor.CELL_NEIGHBOR_SOUTH_DOWN,
	Vector3i( 1,  1, -1): CellNeighbor.CELL_NEIGHBOR_SOUTH_EAST_DOWN,
}

static func is_adjacent(
	source_tile_config: TileConfig, source: Vector3i,
	target_tile_config: TileConfig, target: Vector3i) -> bool:
	return source_tile_config._open_neighbors[
		get_side(source, target)
	] and target_tile_config._open_neighbors[
		get_side(target, source)
	]

static func get_side(source: Vector3i, target: Vector3i) -> CellNeighbor:
	var delta = target - source
	var side = _ADJACENCY_DELTA.get(delta, CellNeighbor.CELL_NEIGHBOR_INVALID)
	assert(
		side != CellNeighbor.CELL_NEIGHBOR_INVALID,
		"ERROR: non-adjacent target cell",
	)
	return side

var _atlas_cell = _INVALID_VECTOR2D
var _open_neighbors = [
	false,  # Invalid placeholder cell.
	
	false, false, false,
	false, false, false,
	false, false, false,
	
	false, false, false,
	false, false, false,
	false, false, false,
	
	false, false, false,
	false, false, false,
	false, false, false,
]

func _init(
	atlas: Vector2i = _INVALID_VECTOR2D,
	neighbors: Array[CellNeighbor] = []):
	_atlas_cell = atlas
	for n in neighbors:
		_open_neighbors[n] = true

func base_atlas_cell() -> Vector2i:
	return _atlas_cell
