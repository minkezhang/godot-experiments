extends CharacterBody2D

const SPEED = 120.0

# Stack of TileMap map coordinates. Stack is in reverse order -- the next
# waypoint tile is at the end of the data struct.
var _waypoints: Array[Vector3i]

func _ready():
	motion_mode = MOTION_MODE_FLOATING

## Get the next source position of the unit.
##
## Pathfinding cannot interrupt a unit's tile-to-tile movement, and therefore
## we will need to report the next "visible" position of the unit.
func get_waypoint() -> Vector3i:
	return Vector3i(
		position.x,
		position.y,
		z_index,
	) if _waypoints.is_empty() else _waypoints[-1]

func stop():
	_waypoints = [ get_waypoint() ]

func set_waypoint(waypoints: Array[Vector3i]):
	_waypoints = waypoints
	_waypoints.reverse()

func _physics_process(delta):
	for i in range(_waypoints.size()):
		var wp = get_waypoint()
		var dx = Vector2(wp.x, wp.y) - position
		var v = dx.normalized() * SPEED
		
		set_velocity(v)
		
		if (
			dx.length() == 0
		) or (
			dx.length() < (v * delta).length()
		):
			_waypoints.pop_back()
			
			position.x = wp.x
			position.y = wp.y
		else:
			break
	
	move_and_slide()
