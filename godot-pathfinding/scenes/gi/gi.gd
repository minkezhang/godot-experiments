extends CharacterBody2D

const SPEED = 120.0

static func map_to_local(map: Vector2i) -> Vector2:
	return Vector2(map * 64) + Vector2(32, 32)

static func local_to_map(local: Vector2) -> Vector2i:
	return Vector2i(int(round(local.x)) / 64, int(round(local.y)) / 64)

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
	var wp = local_to_map(position)
	return Vector3i(
		wp.x,
		wp.y,
		z_index,
	) if _waypoints.is_empty() else _waypoints[-1]

func stop():
	_waypoints = [ get_waypoint() ]

func set_waypoint(waypoints: Array[Vector3i]):
	_waypoints = waypoints
	_waypoints.reverse()

# Slide to the next waypoint tile.
func _physics_process(delta):
	for i in range(_waypoints.size()):
		var wp = get_waypoint()
		var wp_local = map_to_local(Vector2i(wp.x, wp.y))
		
		var dx = wp_local - position
		var v = dx.normalized() * SPEED if dx.length() > 0 else Vector2(0, 0)
		
		if (
			dx.length() == 0
		) or (
			dx.length() < (v * delta).length()
		):
			_waypoints.pop_back()
			position.x = wp_local.x
			position.y = wp_local.y
			set_velocity(Vector2(0, 0))
		else:
			set_velocity(v)
			break
	
	move_and_slide()
