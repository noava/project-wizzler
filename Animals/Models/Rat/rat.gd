extends Animal

@onready var mesh: MeshInstance3D = $RatModel/RatArmature/Skeleton3D/Rat

func _ready() -> void:
	var material_id = 1
	if mesh and mesh.get_active_material(material_id):
		var material = mesh.get_active_material(material_id).duplicate()
		material.albedo_color = color_modulation
		mesh.set_surface_override_material(material_id, material)
