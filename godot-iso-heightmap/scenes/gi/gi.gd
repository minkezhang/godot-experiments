extends CharacterBody2D

var m = Transform2D(
	Vector2(0.5, 0.25), Vector2(-0.5, 0.25), Vector2(32, -16)
)

@export var layer: int = 0

signal up_ramp
signal down_ramp

# TODO(minkezhang): Add tile highlight + z-index inspector.

func _physics_process(_delta):
	var p = m * position
	p.y -= 32 * layer  # TODO(minkezhang): Add heightmap offset.
	$Sprite2D.set_global_position(p)
	var tile = Vector2i(floori(position.x / 64), floori(position.y / 64))
	z_index = tile.x + tile.y + layer + 1
	
	

	
	print("raw: " , position, ", tile: ", tile, ", z_index: ", z_index)
