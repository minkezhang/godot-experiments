extends CharacterBody2D

# Cells
var _path: Array

func _ready():
	motion_mode = MOTION_MODE_FLOATING

const SPEED = 60.0
const JUMP_VELOCITY = -400.0

func cancel_path():
	_path = [
	]

func set_path(p: Array):
	var _p = Array(p)
	_p.reverse()  # Current position is last in the stack.
	_p.pop_back() # Get next cell destination.
	if not _path.is_empty():
		_p.append_array([_path[-1]]) # Ensure agent is in the correct cell position.
	_path = _p
	print("_path: ", _path)

func _physics_process(delta):
	if not _path.is_empty():
		z_index = _path[-1].z
		var dx = Vector2(_path[-1].x, _path[-1].y) - position
		var velocity = dx.normalized() * SPEED
		if dx.length() < (velocity * delta).length():
			_path.pop_back()
			set_velocity(Vector2i(0, 0))
		else:
			set_velocity(velocity)
	move_and_slide()
