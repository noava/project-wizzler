extends Node

@export_category("Key Binds")
@export_subgroup("Interacting")
@export var KEY_INTERACT := "interact"
@export var KEY_DROP := "drop"
@export var KEY_THROW := "throw"

@onready var player_model: Node3D = $"../PlayerModel"
@onready var head: Node3D = $"../Head"
@onready var ray_cast: RayCast3D = $"../Head/Camera3D/RayCast3D"
@onready var item_holder: Node3D = $"../Head/ItemHolder"
@onready var pickup_label: Label = $"../HUD/PickupLabel"

var holding_item = false
var item_data = null

func _process(_delta: float) -> void:
	handle_interactions()
	
	if Input.is_action_just_pressed(KEY_DROP):
		if get_tree().get_first_node_in_group("player").is_on_floor(): # Player on floor
			place_carried_item()
		else:
			throw_carried_item()


func handle_interactions() -> void:
	var interact_pressed = Input.is_action_just_pressed(KEY_INTERACT)
	
	if not ray_cast.is_colliding():
		pickup_label.visible = false
		return
	
	var collider = ray_cast.get_collider()
	if not collider:
		pickup_label.visible = false
		return
	
	# Handle jar
	if collider.is_in_group("jar"):
		var can_insert = holding_item and item_data and item_data.is_in_group("animal") and not collider.animal_data
		var can_extract = not holding_item and collider.animal_data
		
		if can_insert or can_extract:
			pickup_label.visible = true

			if can_insert:
				pickup_label.text = "Press [E] to insert animal"
			else:
				pickup_label.text =  "Press [E] to take out animal"
			
			if interact_pressed:
				if can_insert:
					collider.use_jar(item_data)
					remove_held_item()
				else:
					var animal_object = collider.animal_data
					collider.use_jar(animal_object)
					carry_item_from_world(animal_object)
			return
	
	# Handle pickupable items when not holding anything
	if collider.is_in_group("pickupable") and not holding_item:
		pickup_label.visible = true
		pickup_label.text = "Press [E] to pick up"
		
		if interact_pressed:
			carry_item_from_world(collider)
		return
	
	# Handle collectable items
	if collider.is_in_group("collectable"):
		pickup_label.visible = true
		pickup_label.text = "Press [E] to collect"
		
		if interact_pressed:
			collider.collect()
			pass
		return
	
	# Handle other usable objects
	if collider.has_method("use_object"):
		pickup_label.visible = true
		pickup_label.text = "Press [E] to use"
		
		if interact_pressed:
			collider.use_object()

		return
	
	pickup_label.visible = false


func carry_item_from_world(carried_node: Node3D):
	holding_item = true
	item_data = carried_node
	
	var collision_shape = carried_node.get_node_or_null("CollisionShape3D")
	if collision_shape:
		collision_shape.disabled = true

	if carried_node is RigidBody3D:
		carried_node.gravity_scale = 0
		carried_node.freeze = true
		carried_node.linear_velocity = Vector3.ZERO
		carried_node.angular_velocity = Vector3.ZERO
	
	if carried_node is Animal:
		carried_node.picked_up = true
	
	carried_node.reparent(item_holder)
	carried_node.position = Vector3(0, 0, 0)
	carried_node.rotation = Vector3(0, 0, 0)


func place_carried_item():
	if item_holder.get_child_count() == 0:
		return
	var carried_node = item_holder.get_child(0)
	carried_node.reparent(get_tree().get_current_scene())

	carried_node.global_position = head.global_position - head.global_transform.basis.z * 1.0 # 1 meter in front of head
	carried_node.rotation = player_model.rotation

	var collision_shape = carried_node.get_node_or_null("CollisionShape3D")
	if collision_shape:
		collision_shape.disabled = false

	if carried_node is RigidBody3D:
		carried_node.gravity_scale = 1
		carried_node.freeze = false

	if carried_node is Animal:
		carried_node.picked_up = false
	remove_held_item()


func throw_carried_item():
	if not holding_item or item_holder.get_child_count() == 0:
		return
	
	var carried_node = item_holder.get_child(0)
	place_carried_item()

	if carried_node and carried_node is RigidBody3D:
		var throw_direction = -head.global_transform.basis.z.normalized()
		carried_node.apply_central_impulse(throw_direction * 8.0)


func remove_held_item():
	holding_item = false
	item_data = null
