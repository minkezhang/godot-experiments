extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	body = body as Unit
	if body.mock_velocity().dot(Vector2i(-2, 1)) > 0:
		body.z_index = 1


func _on_body_exited(body):
	body = body as Unit
	if body.mock_velocity().dot(Vector2i(2, -1)) > 0:
		body.z_index = 3
