extends CharacterBody2D

class_name Unit

const SPEED = 5.0
const JUMP_VELOCITY = -400.0

var _last_tick_position = Vector2i(position)

var _n_cliffs: int = 0

func register_cliff():
	_n_cliffs += 1

func unregister_cliff():
	_n_cliffs -= 1

func cliff_count() -> int:
	return _n_cliffs

# Z:
# SUBTERRANEAN (TUNNEL)
# GROUND (TERRAIN)
# ELEVATED (CLIFF)
# BRIDGE  (on a second tilemap entirely)
# All cliffs are of z-index 1?
# TODO(minkezhang): Force z-index for N and E behind cliffs to be -1
# TODO(minkezhang): Force z-index for bridge-adjacent to 2

func _physics_process(delta):
	_last_tick_position = position
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction:
		direction.y /= 2
		position += direction.normalized() * SPEED

func mock_velocity():
	return position - _last_tick_position
