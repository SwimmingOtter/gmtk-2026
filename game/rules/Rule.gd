class_name Rule extends Node

var description: String

func _init(desc: String) -> void:
	description = desc


static func is_unique() -> bool:
	return false
