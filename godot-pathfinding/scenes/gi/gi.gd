extends CharacterBody2D

func _ready():
	motion_mode = MOTION_MODE_FLOATING
	$"NavigationAgent2D".path_desired_distance = 100

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
