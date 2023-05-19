extends CharacterBody2D

var m = Transform2D(
	Vector2(0.5, 0.25), Vector2(-0.5, 0.25), Vector2(32, -16)
)

func _physics_process(_delta):
	var p = m * position
	$Sprite2D.set_global_position(p)
	var tile = Vector2i(floori(position.x / 64), floori(position.y / 64))
	z_index = tile.x + tile.y + 11
	print("raw: " , position, ", tile: ", tile, ", z_index: ", z_index)
