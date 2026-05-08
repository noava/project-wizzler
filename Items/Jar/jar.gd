extends Node3D
@onready var animal_holder: Node3D = $Animals
@onready var lid: MeshInstance3D = $jar/Lid
@onready var animal_name: Label = %AnimalName
@onready var name_plate: MeshInstance3D = $jar/NamePlate

var animal_data = null

func _ready() -> void:
	animal_name.text = ""
	name_plate.visible = false
	lid.visible = false

func use_jar(animal_object) -> void:
	# Store animal if empty
	if !animal_data:
		animal_object.get_node("CollisionShape3D").disabled = true
		animal_object.reparent(animal_holder)
		animal_object.position = Vector3(0, 0.1, 0)
		animal_object.rotation = Vector3(0, 0, 0)
		animal_data = animal_object
		animal_name.text = str(animal_data.animal_name)
		name_plate.visible = true
		lid.visible = true

	# Extract animal
	else:
		animal_data = null
		animal_name.text = ""
		name_plate.visible = false
		lid.visible = false
