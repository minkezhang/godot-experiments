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
## Developers should only edit the Base TileMap.

# Void tiles are empty barriers used for pathfinding and collisions, but are
# invisible when rendered.
var void_atlas_coords = Vector2i(0, 0)

## Identify an (x, y, z) tile in the Base TileMap which lies beneath the mouse
## position.
##
## The (x, y) coordinates represent the "true" coordinates of the tile, not the
## rendered offset as it appears in the Render TileMap. Will return (-1, -1, -1)
## if the mouse is hovering over an opaque and unselectable cell, or if over the
## void.
func select_tile(local: Vector2) -> Vector3i:
	return _get_selected_tile(
		local,
		_get_stack(
		_get_neighbors_apparent(local)))

## Draw a selection sprite over the given tiles.
func highlight_tiles(cells: Array[Vector3i]):
	for c in $Highlight._highlights:
		$Highlight.erase_cell(c.z, _base_to_render_cell(c.z, Vector2i(c.x, c.y)))

	$Highlight._highlights.clear()

	for c in cells:
		if c.z >= 0:
			$Highlight._highlights.append_array([c])
			$Highlight.set_cell(
				c.z,
				_base_to_render_cell(c.z, Vector2i(c.x, c.y)),
				$Base.get_cell_source_id(c.z, Vector2i(c.x, c.y)),
				$Base.get_cell_atlas_coords(c.z, Vector2i(c.x, c.y)))

## Calculate the isometric map coordinates which corresponds to the input
## grid cell.
##
## Isometric tiles need to convey depth, which means tiles in higher orthogonal
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
## A fully opaque isometric tile is rendered as a hexagon. Any detected tile D
## may overlap up to three other hexagons --
##
##  A
## B C
##  D
##
##  ^ camera
##
## Depending on if the click is detected on the left or right side of the tile,
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

## Returns the list of true cell positions at each layer, if a tile exists at
## the cell position.
##
## Returned positions are in reverse draw order, and is represented as
## (x, y, z).
func _get_stack(apparent_neighbors: Array[Vector2i]) -> Array[Vector3i]:
	var stack : Array[Vector3i] = []
	var actual : Vector2i
	for layer in range($Base.get_layers_count() - 1, -1, -1):
		for apparent in apparent_neighbors:
			actual.x = apparent.x + layer
			actual.y = apparent.y + layer
			if _cell_is_occupied(layer, actual):
				stack.append_array([Vector3i(actual.x, actual.y, layer)])
	return stack

func _get_selected_tile(local: Vector2, stack: Array[Vector3i]) -> Vector3i:
	var origin = Vector2(32, 16)
	for actual in stack:
		# Calculate which pixel to inspect in the sprite.
		var offset : Vector2i = local - $Render.map_to_local(
				_base_to_render_cell(actual.z, Vector2i(actual.x, actual.y))) + origin
		
		var atlas_cell = $Base.get_cell_atlas_coords(actual.z, Vector2i(actual.x, actual.y))
		var source_id = $Base.get_cell_source_id(actual.z, Vector2i(actual.x, actual.y))
		var source = $Mask.tile_set.get_source(source_id)
		var source_cell = source.get_tile_at_coords(atlas_cell)
		var tile_origin = Vector2i(
			source_cell.x * source.texture_region_size.x,
			source_cell.y * source.texture_region_size.y,
		)
		
		var check = source.texture.get_image().get_pixelv(tile_origin + offset)
		
		# We have an opaque part of the block and cannot check tiles lower in the stack.
		if check == Color.BLACK:
			break
		
		# We have found a target tile.
		if check == Color.WHITE:
			return actual
			
		# Else, we have hit a transparent part of the mask, and should continue
		# to the next tile in the stack.
	
	return Vector3i(-1, -1, -1)  # Invalid tile.

func _cell_is_occupied(layer: int, actual: Vector2i) -> bool:
	return $Base.get_cell_source_id(layer, actual) >= 0 and (
		$Base.get_cell_atlas_coords(layer, actual) != void_atlas_coords)

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
		
		# Copy corresponding textures to the rendered TileMap.
		for c in $Base.get_used_cells(i):
			var atlas = $Base.get_cell_atlas_coords(i, c)
			$Render.set_cell(
				i,
				_base_to_render_cell(i, c),
				$Base.get_cell_source_id(i, c),
				atlas)
