extends Node2D

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

## Dynamically generates the Render TileMap.
func _ready():
	var dts = DynamicTileSetSource.new(
		$Render.tile_set,
		$Render.tile_set.get_source(0),
		Vector3i(
			$Base.get_used_rect().position.x,
			$Base.get_used_rect().position.y,
			0),
		Vector3i(
			$Base.get_used_rect().size.x,
			$Base.get_used_rect().size.y,
			$Base.get_layers_count()))
	
	$Base.visible = false
	
	for i in range($Render.get_layers_count() - 1, -1, -1):
		$Render.remove_layer(i)
	
	for i in range($Base.get_layers_count()):
		$Render.add_layer(i)
		$Render.set_layer_y_sort_enabled(i, true)
		$Render.set_layer_z_index(i, i)
		
		# Copy corresponding textures to the rendered TileMap.
		for c in $Base.get_used_cells(i):
			var atlas = $Base.get_cell_atlas_coords(i, c)
			$Render.set_cell(
				i,
				_base_to_render_cell(i, c),
				dts.get_source(Vector3i(c.x, c.y, i)),
				atlas)
