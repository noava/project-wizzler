class_name Animal extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_tree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")

@export var animal_name: String = ""
@export var color_modulation: Color = Color(1,1,1)
@export var min_distance: float = 1
@export var activation_distance: float = 5
@export var speed: float = 5

var picked_up: bool = false

func _physics_process(delta: float) -> void:
	if picked_up:
		idle()
		return
	
	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance < activation_distance:
			var away_direction = global_position - player.global_position
			away_direction.y = 0.0
			if away_direction.length_squared() < 0.0001:
				away_direction = -global_transform.basis.z
			away_direction = away_direction.normalized()
			
			update_target_location(global_position + away_direction * min_distance)
			
	var current_location = global_transform.origin
	var next_location = nav_agent.get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	new_velocity.y = velocity.y

	velocity = new_velocity

	# Look towards the way it's running.
	var move_dir := velocity
	move_dir.y = 0.0
	if move_dir.length_squared() > 0.0001:
		look_at(global_position - move_dir)
	
	# Apply gravity
	if not is_on_floor():
		velocity.y -= 9.8 * delta
	
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	if ground_speed > 0.5:
		run()
	else:
		idle()
	
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location  

func idle():
	state_machine.travel("Sit")

func run():
	state_machine.travel("Run")

func attack():
	state_machine.travel("Attack")
