extends CharacterBody2D

const SPEED = 5.0
const JUMP_VELOCITY = -400.0

# Z:
# SUBTERRANEAN (TUNNEL)
# GROUND (TERRAIN)
# ELEVATED (CLIFF)
# BRIDGE  (on a second tilemap entirely)
# All cliffs are of z-index 1?
# TODO(minkezhang): Force z-index for N and E behind cliffs to be -1
# TODO(minkezhang): Force z-index for bridge-adjacent to 2

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		direction.y /= 2
		position += direction.normalized() * SPEED
