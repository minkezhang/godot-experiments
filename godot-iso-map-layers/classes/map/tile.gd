extends Resource

class_name Tile

var _t: TileConfig.T = TileConfig.T.TILE_NONE

# Grid coordinates for the tile.
var _position: Vector3i = Vector3i(-1, -1, -1)

# Sprites which overlap this tile need to set their z-index to this value.
var _z_index: int = 0

func _init(t: TileConfig.T, p: Vector3i, z: int = -1):
	_t = t
	_position = p
	_z_index = z if z >= 0 else p.z
