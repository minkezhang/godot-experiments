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
		print("DEBUG(gi): path not empty, adding %s to head" % [_path[-1]])
		_p.append_array([_path[-1]]) # Ensure agent is in the correct cell position.
	_path = _p
	print("DEBUG(gi): _path = ", _path)

func get_source() -> Vector2:
	if _path.is_empty():
		return position
	else:
		return Vector2(
			_path[-1].x,
			_path[-1].y,
		)

func _physics_process(delta):
	var valid = false
	
	var dx: Vector2
	var v: Vector2i
	var z: int
	
	var buf: Vector3i
	for i in range(_path.size()):
		buf = _path[-1]
		dx = Vector2(buf.x, buf.y) - position
		z = buf.z
		v = dx.normalized() * SPEED
		
		if dx.length() == 0 or dx.length() < (v * delta).length():
			_path.pop_back()
			position.x = buf.x
			position.y = buf.y
			continue
		else:
			valid = true
			break
	
	if valid:
		z_index = z
		set_velocity(v)
	else:
		set_velocity(Vector2(0, 0))
	
	move_and_slide()
