@tool
extends Node3D

@export var image_texture: Texture2D
@export var paper_color: Color = Color(1.0, 0.95, 0.8, 1.0)

@onready var mesh: MeshInstance3D = $Plane

func _ready() -> void:
	var override: StandardMaterial3D = mesh.material_override.duplicate()
	override.albedo_color = paper_color
	mesh.material_override = override
	
	var overlay: StandardMaterial3D = mesh.material_overlay.duplicate()
	overlay.albedo_texture = image_texture

	if image_texture:
		mesh.material_overlay = overlay
	else:
		mesh.material_overlay = null
