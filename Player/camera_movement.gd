extends Node3D

@export var mouse_sensitivity = 0.1
@export var zoom_fov: float = 25.0
@export var zoom_speed: float = 12.0

@onready var player: CharacterBody3D = $".."
@onready var player_model: Node3D = $"../PlayerModel"
@onready var camera: Camera3D = $Camera3D

# Camera Animations
@onready var camera_animation_player: AnimationPlayer = $CameraAnimationPlayer

# Bob
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0
var current_bob_position = Vector3.ZERO

# FOV
const BASE_FOV = 75.0
const FOV_CHANGE = 1.5

# When opening the menu
var mouse_lock = true

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
func _input(event):
	# Rotate Camera
	if event is InputEventMouseMotion and mouse_lock:
		rotation_degrees.y -= mouse_sensitivity * event.relative.x
		rotation_degrees.x -= mouse_sensitivity * event.relative.y
		rotation_degrees.x = clamp(rotation_degrees.x, -89, 89)

func _process(delta: float) -> void:
	# Update player model rotation to match camera
	player_model.rotation.y = rotation.y
	
	# Crouch
	if player.is_crouching:
		camera_animation_player.stop()
		camera_animation_player.play("camera_crouch", -1, -1, true)
	else:
		camera_animation_player.stop()
		camera_animation_player.play("camera_crouch", -1, 1)
		
	# Head bob
	t_bob += delta * player.velocity.length() * float(player.is_on_floor())
	if mouse_lock:
		current_bob_position = current_bob_position.lerp(_headbob(t_bob), delta * 10.0)
		camera.transform.origin = current_bob_position
	
	# FOV ZOOM
	var velocity_clamped = clamp(player.velocity.length(), 0.5, player.SPRINT_SPEED * 2)
	var base_target_fov = BASE_FOV + FOV_CHANGE * velocity_clamped
	var target_fov = zoom_fov if Input.is_action_pressed("zoom") else base_target_fov
	if Input.is_action_pressed("zoom"): mouse_sensitivity = 0.03
	else: mouse_sensitivity = 0.1

	camera.fov = lerp(camera.fov, target_fov, delta * zoom_speed)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	
	# Disable when aiming camera
	if Input.is_action_pressed("item_secondary_interact"):
		return pos
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
