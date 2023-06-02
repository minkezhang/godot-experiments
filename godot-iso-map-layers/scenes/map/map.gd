extends Node2D

const GI = preload("res://scenes/gi/gi.tscn")

func _ready():
	$Schematic.visible = false
	add_child(
		RTSMap.new(
			$Schematic.get_tiles(),
			$Schematic.n_elevation_layers,
		).get_rts_map(),
	)

	$RTSMap/Terrain.add_child(GI.instantiate())
