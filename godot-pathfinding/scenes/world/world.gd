extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	$Map/GI/NavigationAgent2D.target_position = $Map/Base.map_to_local(Vector2i(11, 5))
	print($Map/GI/NavigationAgent2D.is_target_reachable())
	print($Map/GI/NavigationAgent2D.distance_to_target())
	print()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _physics_process(_delta):
	print($Map/GI/NavigationAgent2D.get_next_path_position())
