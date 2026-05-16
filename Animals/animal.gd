class_name Animal extends CharacterBody3D

@onready var nav_agent: NavigationAgent3D = $NavigationAgent3D
@onready var player = get_tree().get_first_node_in_group("player")
@onready var animation_tree = $AnimationTree
@onready var state_machine: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/StateMachine/playback")
@onready var dust_particles: GPUParticles3D = %DustParticles
@onready var animation_stream: AudioStreamPlayer3D = $AudioStreamPlayer3D

@export_category("Animal Info")
@export var animal_name: String = ""
@export var animal_type: String = ""
@export var color_modulation: Color = Color(1,1,1)

@export_category("Movement")
@export var min_distance: float = 1
@export var crouching_activation_distance: float = 2
@export var walking_activation_distance: float = 5
@export var sprinting_activation_distance: float = 8
@export var speed: float = 5

@export var distance_from_player: int = 25

var picked_up: bool = false
var is_thrown: bool = false

func apply_throw_impulse(impulse: Vector3) -> void:
	velocity = impulse
	is_thrown = true

func _physics_process(delta: float) -> void:
	if picked_up:
		idle()
		if dust_particles:
			dust_particles.emitting = false
		return
	
	if is_thrown:
		if not is_on_floor():
			velocity.y -= 9.8 * delta
			move_and_slide()
			return
		is_thrown = false

	if player:
		var distance = global_position.distance_to(player.global_position)
		
		var actual_activation_distance 
			
		if player.is_crouching:
			actual_activation_distance = crouching_activation_distance
		elif player.is_sprinting:
			actual_activation_distance = sprinting_activation_distance
		else:
			actual_activation_distance = walking_activation_distance
		
		if distance < actual_activation_distance:
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
	
	# Animal animations based on speed
	var ground_speed := Vector2(velocity.x, velocity.z).length()
	if ground_speed > 0.5:
		run()
	else:
		idle()

	if dust_particles:
		dust_particles.emitting = is_on_floor() && ground_speed > 0.5
	
	# Sounds
	if player:
		relative_to_player_sound()
	
	move_and_slide()

func update_target_location(target_location):
	nav_agent.target_position = target_location  

func idle():
	state_machine.travel("Sit")

func run():
	state_machine.travel("Run")

func attack():
	state_machine.travel("Attack")

func animal_sound():
	await get_tree().create_timer(randf_range(1.0,5.0)).timeout
	animation_stream.pitch_scale = randf_range(0.7,1)
	animation_stream.play()

func relative_to_player_sound():
	var distance = global_position.distance_to(player.global_position)
	
	if animation_stream and distance < distance_from_player and !animation_stream.playing:
		animal_sound()
