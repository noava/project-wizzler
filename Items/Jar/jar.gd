extends Node3D
@onready var animal_holder: Node3D = $Animals
@onready var lid: MeshInstance3D = $jar/Lid

var animal_data = null

func _ready() -> void:
	lid.visible = false

func use_jar(animal_object) -> void:
	# Store animal if empty
	if !animal_data:
		animal_object.get_node("CollisionShape3D").disabled = true
		animal_object.reparent(animal_holder)
		animal_object.position = Vector3(0, 0.1, 0)
		animal_object.rotation = Vector3(0, 0, 0)
		animal_data = animal_object
		lid.visible = true

	# Extract animal
	else:
		animal_data = null
		lid.visible = false
