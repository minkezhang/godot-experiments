extends Node2D

"""
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		$Map/GI/NavigationAgent2D.target_position = $Map/Base.map_to_local(
			$Map/Base.local_to_map(
				$Map/Base.to_local(get_global_mouse_position())
			)
		)
	
func _physics_process(delta):
	var tile_position = $Map/Base.map_to_local(
		$Map/Base.local_to_map(
			$Map/Base.to_local($Map/GI/NavigationAgent2D.get_next_path_position())
		)
	)
	var speed = 30
	var velocity = (tile_position - $Map/GI.position).normalized() * speed
	
	# Reduce end-state jitter.
	if (velocity * delta).length() >= (tile_position - $Map/GI.position).length():
		$Map/GI.position = tile_position
		print("JITTER")
	else:
		$Map/GI.set_velocity(velocity)
		$Map/GI.move_and_slide()
"""
