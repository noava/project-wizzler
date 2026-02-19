extends Node3D
# TODO: Change to camera objects camera viewport
@onready var cam_ui: CanvasLayer = $CamUI

@export_category("Insect Detection")
@export var distance_from_camera: float = 2.0

@export_category("Aim Camera")
@export var aim_speed: float = 10.0

@export_category("Zoom")
@export var min_fov: float = 10.0
@export var max_fov: float = 90.0
@export var zoom_step: float = 10.0

var camera_equipped = false
var original_position: Vector3
var aiming_camera = false

func _ready() -> void:
	original_position = self.position
	$".".hide()
	cam_ui.get_node("TextureRect").hide() ## TEMP

func _process(delta: float) -> void:
	$SubViewport/Camera3D.global_transform = self.global_transform
	
	if Input.is_action_just_pressed("equip_camera"):
		equip_camera()
	if camera_equipped:
		_snap_picture()
		_aim_camera(delta)
		_zoom_camera()


func _snap_picture():
	if not Input.is_action_just_pressed("item_interact"):
		return
	
	print("taking a picture")
	var viewport = $SubViewport
	var texture = viewport.get_texture()
	var imgtex = ImageTexture.create_from_image(texture.get_image())
	
	print(get_insects_in_frame())
	
	Global.imagesTaken.append({
		"texture": imgtex,
		"insects": get_insects_in_frame()
	})
	cam_ui.get_node("TextureRect").texture = imgtex

func get_insects_in_frame() -> Array:
	var camera = $SubViewport/Camera3D
	var insects_in_frame = []
	
	# Don't know how this scales up when there are many insects in scene.
	for insect in get_tree().get_nodes_in_group("insect"):
		var distance = camera.global_position.distance_to(insect.global_position)
		if camera.is_position_in_frustum(insect.global_position) and distance <= distance_from_camera:
			# TODO: Don't count insects behind objects?
			# TODO: Zoom allows insects to be detected on longer distances. Make another zoom function for camera using scrollwheel
			# TODO: Change to insect.data to get more info from the insect. Use a resource
			insects_in_frame.append(str(insect.name))
	
	return insects_in_frame

func _aim_camera(delta: float):
	var camera_target_pos = Vector3(0.025, 0, -0.65) if Input.is_action_pressed("item_secondary_interact") else original_position
	self.position = self.position.lerp(camera_target_pos, delta * aim_speed)

func equip_camera():
	camera_equipped = !camera_equipped
	
	if camera_equipped:
		$".".show()
		cam_ui.get_node("TextureRect").show() ## TEMP
	else:
		$".".hide()
		cam_ui.get_node("TextureRect").hide() ## TEMP

func _zoom_camera():
	var camera = $SubViewport/Camera3D
	if Input.is_action_just_pressed("camera_zoom_in"):
		camera.fov = clamp(camera.fov - zoom_step, min_fov, max_fov)
	elif Input.is_action_just_pressed("camera_zoom_out"):
		camera.fov = clamp(camera.fov + zoom_step, min_fov, max_fov)
