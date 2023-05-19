class_name Movement

static func map_to_local(map: Vector2i) -> Vector2:
	return Vector2(map * 64) + Vector2(32, 32)

static func local_to_map(local: Vector2) -> Vector2i:
	return Vector2i(floori(local.x / 64), floori(local.y / 64))
