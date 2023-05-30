extends Node2D

# Schematic wraps a technical map.
#
# This node is not visible at runtime, but is used to generate the isometric
# maps used by the game.
#
# Tiles between the Terrain and Cliff TileMaps must not overlap with one
# another and must not overlap tiles from other layers within the same TileMap.
#
# Bridge tiles may overlap Terrain tiles.

var _tile_config = TileConfig.new()

var n_elevation_layers: int = 1

func _ready():
	n_elevation_layers = max(
		$Terrain.get_layers_count(),
		$Cliff.get_layers_count(),
		$Bridge.get_layers_count(),
	)

func get_tiles() -> Array[Tile]:
	var tiles: Array[Tile] = []
	for i in $Terrain.get_layers_count():
		for t in $Terrain.get_used_cells(i):
			var atlas = $Terrain.get_cell_atlas_coords(i, t)
			var config = _tile_config.get_by_schematic(
				Vector3i(atlas.x, atlas.y, $Terrain.get_cell_source_id(i, t)))
			tiles.append(Tile.new(
				config.get_tile(), Vector3i(t.x, t.y, i),
			))
	for i in $Cliff.get_layers_count():
		for t in $Cliff.get_used_cells(i):
			var atlas = $Cliff.get_cell_atlas_coords(i, t)
			var config = _tile_config.get_by_schematic(
				Vector3i(atlas.x, atlas.y, $Cliff.get_cell_source_id(i, t)))
			tiles.append(Tile.new(
				config.get_tile(), Vector3i(t.x, t.y, i),
			))
	return tiles
