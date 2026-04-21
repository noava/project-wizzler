class_name Spin extends Node3D

@export var speed: float = 1.1

func _process(delta: float) -> void:
	get_parent().rotate_y(speed * delta)
