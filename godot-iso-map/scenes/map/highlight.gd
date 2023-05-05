extends TileMap

enum { SELECT, VALID, INVALID }

var _highlights : Array


func set_highlights(h : Array, t : int):
	for c in _highlights:
		erase_cell(c["layer"], c["cell"] - Vector2i(c["layer"], c["layer"]))

	_highlights.clear()

	for c in h:
		if c.get("layer", -1) >= 0:
			var d = c["cell"] - Vector2i(c["layer"], c["layer"])
			_highlights.append_array([c])
			set_cell(c["layer"], d, 0, Vector2i(t, 0))
