extends Animal

@onready var mesh: MeshInstance3D = $Muskrat_Animations/Rig/Skeleton3D/Mesh

func _ready() -> void:
	if mesh and mesh.get_active_material(0):
		var material = mesh.get_active_material(0).duplicate()
		material.albedo_color = color_modulation
		mesh.set_surface_override_material(0, material)
	animal_sound()
	
func animal_sound():
	await get_tree().create_timer(randf_range(1.0,5.0)).timeout
	$AudioStreamPlayer3D.pitch_scale = randf_range(0.7,1)
	$AudioStreamPlayer3D.play()
	animal_sound()
