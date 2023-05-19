class_name DynamicTileSetSource

const _INVALID_ATLAS_TILE = Vector2i(-1, -1)

var _source_lookup = {
}

func _init(tileset: TileSet, template: TileSetAtlasSource, origin: Vector3i, size: Vector3i):
	var _min = origin.x + origin.y + origin.z
	var _max = size.x + size.y + size.z
	
	for k in range(_max - _min):
		var s = TileSetAtlasSource.new()
		s.texture = template.texture
		s.margins = template.margins
		s.separation = template.separation
		s.texture_region_size = template.texture_region_size
		s.use_texture_padding = template.use_texture_padding
		
		_source_lookup[_min + k] = tileset.add_source(s)
	
	for i in range(template.get_atlas_grid_size().x):
		for j in range(template.get_atlas_grid_size().y):
			var atlas = Vector2i(i, j)
			if template.get_tile_at_coords(atlas) != _INVALID_ATLAS_TILE:
				for k in range(_max - _min):
					var source = tileset.get_source(_source_lookup[_min + k])
					if source.get_tile_at_coords(atlas) == _INVALID_ATLAS_TILE:
						source.create_tile(
							atlas,
							template.get_tile_size_in_atlas(atlas))
						source.get_tile_data(atlas, 0).texture_origin = template.get_tile_data(atlas, 0).texture_origin
						source.get_tile_data(atlas, 0).y_sort_origin = template.get_tile_data(atlas, 0).y_sort_origin
						source.get_tile_data(atlas, 0).z_index = k

func get_source(cell: Vector3i) -> int:
	return _source_lookup.get(cell.x + cell.y + cell.z, -1)
