extends Node2D

var _map: Map

# Called when the node enters the scene tree for the first time.
func _ready():
	Map.Metadata.new().generate_atlas_source(1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
