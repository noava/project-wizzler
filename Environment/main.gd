extends Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(FadeManager.color_rect.color.a)
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().physics_frame
	await get_tree().physics_frame
	await FadeManager.fade(0.0, 3).finished
