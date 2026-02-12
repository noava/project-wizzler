extends Node3D
@onready var insect_holder: Node3D = $Insects
@onready var lid: MeshInstance3D = $jar/Lid

var insect_data = null

func _ready() -> void:
	lid.visible = false

func use_object(insect_object) -> void:
	# Store insect if empty
	if !insect_data:
		insect_object.get_node("CollisionShape3D").disabled = true
		insect_object.gravity_scale = 0
		insect_object.freeze = true
		insect_object.linear_velocity = Vector3.ZERO
		insect_object.angular_velocity = Vector3.ZERO
		insect_object.reparent(insect_holder)
		insect_object.position = Vector3(0, 0.1, 0)
		insect_object.rotation = Vector3(0, 0, 0)
		insect_data = insect_object
		lid.visible = true

	# Extract insect
	else:
		insect_data = null
		lid.visible = false
