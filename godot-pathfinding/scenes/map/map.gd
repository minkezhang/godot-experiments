extends Node2D

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



const _VOID_ATLAS_COORDS = Vector2i(0, 0)
var _astar: AStar3D

var _ATLAS_GRASS = Vector2i(2, 0)

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
			if $Base.get_cell_atlas_coords(i, n) == _ATLAS_GRASS:
				var source = Vector3i(n.x, n.y, i)
				
				var _corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_TOP_LEFT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_TOP_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source), pack(Vector3i(_corner.x, _corner.y, i)))
				
				_corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source), pack(Vector3i(_corner.x, _corner.y, i)))

				_corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_TOP_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source), pack(Vector3i(_corner.x, _corner.y, i)))

				_corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source), pack(Vector3i(_corner.x, _corner.y, i)))

				for c in $Base.get_surrounding_cells(n):
					if $Base.get_cell_atlas_coords(i, c) == _ATLAS_GRASS:
						var target = Vector3i(c.x, c.y, i)
						_astar.connect_points(pack(source), pack(target))

