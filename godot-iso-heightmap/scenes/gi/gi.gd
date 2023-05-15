extends CharacterBody2D

var m = Transform2D(
	Vector2(0.5, 0.25), Vector2(-0.5, 0.25), Vector2(32, -16)
)

func _physics_process(delta):
	var p = m * position
	$Sprite2D.set_global_position(p)
	z_index = 1  # tile layer + 1
