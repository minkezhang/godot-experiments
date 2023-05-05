extends Node2D

## Isometric map representation script.
##
## The layout, collision hitboxes, and navigation layers are all contained in
## the Base TileMap layer. This TileMap is used to generate the isometric view
## managed by the Render TileMap.
##
## An additional Highlight TIleMap UI layer is also included, which affords
## the ability to add more user-driven sprites to the scene.
##
## Developers should not touch the Render and Highlight nodes.

# Void cells are empty barriers used for pathfinding and collisions, but are
# invisible when rendered.
var void_atlas = Vector2i(0, 0)

## Calculate the isometric map coordinates which corresponds to the input
## grid cell.
##
## Isometric tiles need to convey depth, which means cells in higher orthogonal
## grid layers need to "float". 
func _base_to_render_cell(layer: int, ortho: Vector2i) -> Vector2i:
	# We are treating higher TileMap layers as higher in elevation, which means
	# they should be drawn above the bottom tiles in 3D.
	#
	# This assumes the tile_layout property of the TileSet is DIAMOND_DOWN.
	return Vector2i(ortho.x - layer, ortho.y - layer)

## Get neighboring apparent cells which the current mouse position may be
## targeting.
##
## A fully opaque isometric tile is rendered as a hexagon. Any detected cell D
## may overlap up to four other hexagons --
##
##  A
## B C
##  D
##
## Depending on if the click is detected on the left or right side of the cell,
## we can filter out either B or C.
##
## Returns the apparent neighbors in reverse draw order (that is, return D,
## then either B or C, then A).
func _get_neighbors_apparent(local: Vector2) -> Array[Vector2i]:
	var apparent = $Render.local_to_map(local)
	var offset = local - $Render.map_to_local(apparent)
	# If X < 0, then the cursor lies on the left half of the tile; this means
	# that we need to check for partial left-side occlusion.
	if offset.x < 0:
		return [
			apparent,                                  # D
			Vector2i(apparent.x - 1, apparent.y),      # B
			Vector2i(apparent.x - 1, apparent.y - 1),  # A

		]
	return [
			apparent,                                  # D
			Vector2i(apparent.x, apparent.y - 1),      # C
			Vector2i(apparent.x - 1, apparent.y - 1),  # A
	]

## Returns the list of true cell positions at each layer, if such a cell exists.
##
## Returned cells are in reverse draw order, and is represented as (x, y, z).
func _get_rendered_stack(apparent_neighbors: Array[Vector2i]) -> Array[Vector3i]:
	var stack : Array[Vector3i] = []
	var actual : Vector2i
	for layer in range($Base.get_layers_count() - 1, -1, -1):
		for apparent in apparent_neighbors:
			actual.x = apparent.x + layer
			actual.y = apparent.y + layer
			if cell_is_occupied(layer, actual):
				stack.append_array([Vector3i(actual.x, actual.y, layer)])
	return stack

func cell_is_occupied(layer: int, actual: Vector2i) -> bool:
	return $Base.get_cell_source_id(layer, actual) >= 0 and (
		$Base.get_cell_atlas_coords(layer, actual) != void_atlas)

## Select the appropriate (layer, cell) from the given local mouse coordinates.
func select_cell(local: Vector2):
	var apparent = $Render.local_to_map(local)
	var actual : Vector2i
	
	var center = $Render.map_to_local(apparent)
	var offset = local - center
	
	var layer : int
	var found = false
	var n = $Base.get_layers_count()
	for l in range(n - 1, -1, -1):
		var shift = Vector2i(l, l)
		if cell_is_occupied(l, apparent + shift):
			found = true
			layer = l
			actual = apparent + shift
			break
	
	if not found:
		return {}
	
	# Cannot select a cell if the immediate layer above is occupied.
	if layer + 1 < n and cell_is_occupied(layer + 1, actual):
		return {}
	
	# We do not need to check cells in the same layer.
	for l in range(n - 1, layer, -1):
		var shift = Vector2i(l - layer - 1, l - layer - 1)
		
		# Target may be obscured by cell on a higher level (i.e. A is obscured by
		# D).
		#
		#  A
		# B C
		#  D
		#
		# We do not need to check the case where A is obscured by D; in this 
		# case, the cell would never be visible, and we would have returned D.
		var check : Vector2i
		
		# If X < 0, then the cursor lies on the left half of the tile; this
		# means that we need to check for partial left-side occlusion.
		if offset.x < 0:
			# Target may be obscured by a left-adjacent cell on a higher level,
			# i.e. A is obscured by B.
			check = Vector2i(0, 1)
		else:
			# Target may be obscured by a right-adjacent cell on a higher level,
			# i.e. A is obscured by C.
			check = Vector2i(1, 0)
		
		if cell_is_occupied(l, actual + check + shift):
			return {}
	
	return {
		"layer": layer,
		"cell": actual,
	}


## Dynamically generates the Render TileMap.
func _ready():
	$Base.visible = false
	
	for i in range($Render.get_layers_count()):
		$Render.remove_layer(i)
	for i in range($Highlight.get_layers_count()):
		$Highlight.remove_layer(i)
	
	for i in range($Base.get_layers_count()):
		$Render.add_layer(i)
		$Render.set_layer_y_sort_enabled(i, true)
		$Render.set_layer_z_index(i, i)
		
		# Sprites from Highlight may need to sit behind some cells. This means
		# we want to associate the z-layer data along-side the cell coordinates.
		$Highlight.add_layer(i)
		$Highlight.set_layer_y_sort_enabled(i, true)
		$Highlight.set_layer_z_index(i, i)

		for c in $Base.get_used_cells(i):
			var atlas = $Base.get_cell_atlas_coords(i, c)
			$Render.set_cell(
				i,
				_base_to_render_cell(i, c),
				$Base.get_cell_source_id(i, c),
				atlas)
