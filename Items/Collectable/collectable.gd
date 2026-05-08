@tool
extends Node3D

@export var model_scene: PackedScene # The 3D model
@export var item_scene: PackedScene # The item you want the player to collect

func _ready() -> void:
	var scene = model_scene.instantiate()
	add_child(scene)

func collect():
#	var scene = item_scene.instantiate()
#	get_tree().get_first_node_in_group("player").get_node("Inv").add_child(scene)

	Global.camera_in_inv = true # TEMP. Remove if finishing inv system
	queue_free()
