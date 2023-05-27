extends Node2D

func _ready():
	$Schematic.visible = false
	add_child(
		RTSMap.new(
			$Schematic.get_tiles(),
			$Schematic.n_elevation_layers,
		).get_rts_map(),
	)
