extends Node3D
# TODO: Change to camera objects camera viewport
@onready var texture_rect: TextureRect = $CamUI/TextureRect

@export_category("Insect Detection")
@export var distance_from_camera: float = 2.0

@export_category("Aim Camera")
@export var aim_speed: float = 10.0

@export_category("Zoom")
@export var min_fov: float = 10.0
@export var max_fov: float = 90.0
@export var zoom_step: float = 10.0

@export_category("Audio")
@export var shutter_pitch: float = 0.7
@export var zoom_in_pitch: float = 1.3
@export var zoom_out_pitch: float = 0.8

@onready var audio_player: AudioStreamPlayer3D = $AudioStreamPlayer3D
const CAMERA_SHUTTER = preload("uid://b88rs4vm3pd3o")
const CAMERA_ZOOM = preload("uid://chohbotm6sxv")

var camera_equipped = false
var original_position: Vector3

func _ready() -> void:
	original_position = position
	hide()
	texture_rect.hide() ## TEMP

func _process(delta: float) -> void:
	$SubViewport/Camera3D.global_transform = global_transform
	
	if Input.is_action_just_pressed("equip_camera"):
		equip_camera()
	if camera_equipped:
		_snap_picture()
		_aim_camera(delta)
		_zoom_camera()


func _snap_picture():
	if not Input.is_action_just_pressed("item_interact"):
		return

	audio_player.pitch_scale = shutter_pitch
	audio_player.stream = CAMERA_SHUTTER
	audio_player.play()
	
	print("taking a picture")
	var viewport = $SubViewport
	var texture = viewport.get_texture()
	var imgtex = ImageTexture.create_from_image(texture.get_image())
	
	print(get_insects_in_frame())
	
	Global.imagesTaken.append({
		"texture": imgtex,
		"insects": get_insects_in_frame()
	})
	texture_rect.texture = imgtex

func get_insects_in_frame() -> Array:
	var camera = $SubViewport/Camera3D
	var insects_in_frame = []
	
	# Don't know how this scales up when there are many insects in scene.
	for insect in get_tree().get_nodes_in_group("insect"):
		var distance = camera.global_position.distance_to(insect.global_position)
		if camera.is_position_in_frustum(insect.global_position) and distance <= distance_from_camera:
			# TODO: Don't count insects behind objects?
			# TODO: Zoom allows insects to be detected on longer distances.
			# TODO: Change to insect.data to get more info from the insect. Use a resource
			
			insects_in_frame.append(insect)
	
	return insects_in_frame

func _aim_camera(delta: float):
	var camera_target_pos = Vector3(0.025, 0, -0.65) if Input.is_action_pressed("item_secondary_interact") else original_position
	position = position.lerp(camera_target_pos, delta * aim_speed)

func equip_camera():
	camera_equipped = !camera_equipped
	
	if camera_equipped:
		show()
		texture_rect.show() ## TEMP
	else:
		hide()
		texture_rect.hide() ## TEMP

func _zoom_camera():
	var camera = $SubViewport/Camera3D
	var old_fov = camera.fov
	var zoom_change = 0
	var pitch = 1.0
	
	if Input.is_action_just_pressed("camera_zoom_in"):
		zoom_change = -zoom_step
		pitch = zoom_in_pitch
	elif Input.is_action_just_pressed("camera_zoom_out"):
		zoom_change = zoom_step
		pitch = zoom_out_pitch
	
	if zoom_change != 0:
		camera.fov = clamp(camera.fov + zoom_change, min_fov, max_fov)
		if camera.fov != old_fov:
			audio_player.pitch_scale = pitch
			audio_player.stream = CAMERA_ZOOM
			audio_player.play()
	
	
