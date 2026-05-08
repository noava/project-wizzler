extends Animal

@onready var mesh: MeshInstance3D = $Taipan_Animations/Rig/Skeleton3D/Mesh

func _ready() -> void:
	if mesh and mesh.get_active_material(0):
		var material = mesh.get_active_material(0).duplicate()
		material.albedo_color = color_modulation
		mesh.set_surface_override_material(0, material)
