extends CharacterBody3D

var speed
var WALK_SPEED = 5.0
var CROUCH_SPEED = 3.0
var SPRINT_SPEED = 8.0
var JUMP_VELOCITY = 4.0
const SENSITIVITY = 0.004

@onready var audio = $FootstepAudio

var walk_interval := 0.5
var sprint_interval := 0.25
var crouch_interval := 0.85

var footstep_sound = preload("res://Sounds/Material/walking.mp3")
var inwater_sound = preload("res://Sounds/Material/wading.mp3")

var footstep_timer := 0.0
var footstep_interval := walk_interval

var is_sprinting := false

# Crouch
var is_crouching = false
@export_range(5, 10, 0.1) var CROUCH_ANIM_SPEED : float = 7.0

var gravity = 9.8

@onready var head: Node3D = $Head

# When opening the menu
var movement_lock = false

func _physics_process(delta: float) -> void:
	footstep_timer -= delta
	
	var sprinting = Input.is_action_pressed("sprint")
	var crouching = Input.is_action_pressed("crouch")
	
	if sprinting != is_sprinting or is_crouching != crouching:
		is_sprinting = sprinting
		is_crouching = crouching
		update_footstep_sounds()
		
	var moving = velocity.length() > 0.05 and is_on_floor()
	
	if not moving:
		return
	footsteps_handle(delta)
		
func in_water() -> bool:
	var player_pos = global_transform.origin
	for water in get_tree().get_nodes_in_group("Water"):
		var water_pos = water.global_transform.origin
		
		var dx = player_pos.x - water_pos.x
		var dz = player_pos.z - water_pos.z
		var distance = Vector2(dx,dz).length()
		
		var radius = max(water.scale.x, water.scale.z) * 0.5
		
		if distance <= radius:
			if player_pos.y <= water_pos.y:
				return true
	return false
			
func footsteps_handle(delta):
	footstep_timer -= delta
	
	if footstep_timer <= 0.0:
		footstep_timer = footstep_interval
		play_footstep()

func update_footstep_sounds():

	if Input.is_action_pressed("sprint"):
		footstep_interval = sprint_interval
		audio.pitch_scale = 1.5
	elif Input.is_action_pressed("crouch"):
		footstep_interval = crouch_interval
		audio.volume_db = -999 #silent
	else:
		footstep_interval = walk_interval
		audio.pitch_scale = 1
		
	footstep_timer = 0
	

func play_footstep():
	if audio.playing:
		return
	if in_water():
		audio.stream = inwater_sound
	else:
		audio.stream = footstep_sound

	audio.volume_db = -16
	audio.bus = "Ambient"
	audio.play()
	footstep_timer = max(footstep_interval, audio.stream.get_length())

func _process(delta):
	RenderingServer.global_shader_parameter_set("player_position",global_transform.origin)
	if movement_lock: return

	if in_water():
		WALK_SPEED = 2
		CROUCH_SPEED = 1.0
		SPRINT_SPEED = 4
		JUMP_VELOCITY = 2.0
	else:
		WALK_SPEED = 5.0
		CROUCH_SPEED = 3.0
		SPRINT_SPEED = 8.0
		JUMP_VELOCITY = 4.0
	
	# Gravity
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# Crouch (hold)
	is_crouching = Input.is_action_pressed("crouch")
	
	# Crouch (toggle) Uncomment code below for toggle crouch TODO: Make this as a toggle in settings
	#if Input.is_action_just_pressed("crouch"):
	#	is_crouching = !is_crouching
		
	# Sprint
	if Input.is_action_pressed("sprint") and not is_crouching:
		speed = SPRINT_SPEED
	elif is_crouching:
		speed = CROUCH_SPEED
	else:
		speed = WALK_SPEED
		
	# Movement/Deceleration.
	var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
	var direction = (head.transform.basis * transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
	
	if is_on_floor():
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
	
	move_and_slide()
