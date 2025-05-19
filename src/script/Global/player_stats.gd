extends Node

signal health_changed(new_hp: int)
signal player_died

var _hp: int = 100

var hp: int:
	get:
		return get_hp()
	set(value):
		set_hp(value)

var key1: bool = false
var key2: bool = false

func set_hp(value: int) -> void:
	if value < _hp:
		emit_signal("health_changed", value)
		if value <= 0:
			emit_signal("player_died")
	_hp = max(value, 0)

func get_hp() -> int:
	return _hp
