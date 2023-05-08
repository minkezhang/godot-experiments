extends Node2D


const _VOID_ATLAS_COORDS = Vector2i(0, 0)
var _astargrid: AStarGrid2D

var _NULL_POS = Vector2i(-1, -1)
var source = _NULL_POS
var target = _NULL_POS

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
	
		if source != _NULL_POS and target != _NULL_POS:
			for n in $Highlight.get_used_cells(0):
				$Highlight.erase_cell(0, n)
			$Highlight.set_cell(0, source, 0, Vector2i(1, 0))
			$Highlight.set_cell(0, target, 0, Vector2i(2, 0))
			for n in _astargrid.get_point_path(source, target).slice(1, -1):
				$Highlight.set_cell(0, $Highlight.local_to_map($Highlight.to_local(n)), 0, Vector2i(0, 0))

func _ready():
	_astargrid = AStarGrid2D.new()
	_astargrid.size = $Base.get_used_rect().size
	_astargrid.cell_size = $Base.tile_set.tile_size
	_astargrid.set_diagonal_mode(AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES)
	_astargrid.update()
	for n in $Base.get_used_cells(0):
		var atlas = $Base.get_cell_atlas_coords(0, n)
		if atlas == _VOID_ATLAS_COORDS:
			_astargrid.set_point_solid(n)
		if atlas != Vector2i(2, 0) and atlas != Vector2i(3, 0):
			_astargrid.set_point_solid(n)
