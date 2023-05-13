extends Node2D

var _astar: AStar3D

func astar() -> AStar3D:
	return _astar
	
func _ready():
	_astar = AStar3D.new()
	_astar.reserve_space($Base.get_used_rect().size.x * $Base.get_used_rect().size.y * $Base.get_layers_count())
	for i in range($Base.get_layers_count()):
		for n in $Base.get_used_cells(i):
			_astar.add_point(
				$Base.pack(Vector3i(n.x, n.y, i)),
				Vector3i(n.x, n.y, i))
	
	for i in range ($Base.get_layers_count()):
		for n in $Base.get_used_cells(i):
			var source = Vector3i(n.x, n.y, i)
			for target in $Base.get_adjacent_tiles(source):
				_astar.connect_points($Base.pack(source), $Base.pack(target))
