extends Node2D

func _ready():
	var m = Map.new($Schematic.get_tiles(), $Schematic.n_elevation_layers)
	add_child(m.get_map())
	
	$Schematic.visible = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
