extends Node2D

# TODO(minkezhang): Allow for a TileMap export utility.
var _layout: Array[Map.Tile] = [
	Map.Tile.new(Map.T.TILE_TERRAIN_GRASS, Vector3i(0, 0, 0)),
	Map.Tile.new(Map.T.TILE_RAMP_GRASS_EAST, Vector3i(1, 0, 0)),
	Map.Tile.new(Map.T.TILE_TERRAIN_GRASS, Vector3i(2, 0, 1)),
	Map.Tile.new(Map.T.TILE_RAMP_GRASS_WEST, Vector3i(3, 0, 0)),
	Map.Tile.new(Map.T.TILE_RAMP_GRASS_NORTHEAST, Vector3i(1, 1, 0)),
	Map.Tile.new(Map.T.TILE_RAMP_GRASS_NORTH, Vector3i(2, 1, 0)),
	Map.Tile.new(Map.T.TILE_RAMP_GRASS_NORTHWEST, Vector3i(3, 1, 0)),
]

# Called when the node enters the scene tree for the first time.
func _ready():
	var m = Map.new(_layout)
	add_child(m.map)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
