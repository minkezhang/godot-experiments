extends Node2D


const _VOID_ATLAS_COORDS = Vector2i(0, 0)
var _astar: AStar3D

var _NULL_POS = Vector2i(-1, -1)
var source = _NULL_POS
var target = _NULL_POS

var _ATLAS_GRASS = Vector2i(2, 0)

var _dim: Vector3i

func _process(_delta):
	if Input.is_action_just_pressed("ui_cancel"):
		source = _NULL_POS
		target = _NULL_POS
		for n in $Highlight.get_used_cells(0):
			$Highlight.erase_cell(0, n)
	
	if Input.is_action_just_pressed("ui_accept"):
		var mpos = get_global_mouse_position()
		var tile = $Base.local_to_map($Base.to_local(mpos))
		if source == _NULL_POS:
			source = tile
			$Highlight.set_cell(0, source, 0, Vector2i(1, 0))
		else:
			target = tile
			$Highlight.set_cell(0, target, 0, Vector2i(2, 0))
	
		print(source, target)
		if source != _NULL_POS and target != _NULL_POS:
			print("pathfind source: %s (%s) to target: %s (%s)" % [
				source,
				pack(Vector3i(source.x, source.y, 0), _dim),
				target,
				pack(Vector3i(target.x, target.y, 0), _dim)])
			for n in $Highlight.get_used_cells(0):
				$Highlight.erase_cell(0, n)
			for n in _astar.get_point_path(
				pack(Vector3i(source.x, source.y, 0), _dim),
				pack(Vector3i(target.x, target.y, 0), _dim)):
				$Highlight.set_cell(0, Vector2i(n.x, n.y), 0, Vector2i(0, 0))
				print("path node: %s (%s) " % [n, pack(n, _dim)])
			$Highlight.set_cell(0, source, 0, Vector2i(1, 0))
			$Highlight.set_cell(0, target, 0, Vector2i(2, 0))

func pack(v: Vector3i, dim: Vector3i) -> int:
	return v.x + v.y * dim.x + v.z * dim.x * dim.y

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
				pack(Vector3i(n.x, n.y, i), _dim),
				Vector3i(n.x, n.y, i))
	
	print("_dim: ", _dim)
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
					_astar.connect_points(pack(source, _dim), pack(Vector3i(_corner.x, _corner.y, i), _dim))
				
				_corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_LEFT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_LEFT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source, _dim), pack(Vector3i(_corner.x, _corner.y, i), _dim))

				_corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_TOP_RIGHT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_TOP_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source, _dim), pack(Vector3i(_corner.x, _corner.y, i), _dim))

				_corner = $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_RIGHT_CORNER)
				if $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_BOTTOM_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, $Base.get_neighbor_cell(n, TileSet.CELL_NEIGHBOR_RIGHT_SIDE)
				) == _ATLAS_GRASS and $Base.get_cell_atlas_coords(
					i, _corner
				) == _ATLAS_GRASS:
					_astar.connect_points(pack(source, _dim), pack(Vector3i(_corner.x, _corner.y, i), _dim))

				for c in $Base.get_surrounding_cells(n):
					if $Base.get_cell_atlas_coords(i, c) == _ATLAS_GRASS:
						var target = Vector3i(c.x, c.y, i)
						_astar.connect_points(pack(source, _dim), pack(target, _dim))

