
extends CharacterBody2D

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	$"NavigationAgent2D".path_desired_distance = 100
"""
const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready():
	motion_mode = MOTION_MODE_FLOATING

func _physics_process(delta):
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept"): #  and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_collide(velocity)
"""
