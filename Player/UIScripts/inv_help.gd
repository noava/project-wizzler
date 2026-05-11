extends Control
@onready var camera_snap: Node3D = $"../../Head/CameraSnap"
@onready var camera_text: RichTextLabel = $MarginContainer/RichTextLabel
@onready var hand_text: RichTextLabel = $MarginContainer/RichTextLabel2

func _process(_delta: float) -> void:
	camera_text.visible = camera_snap.camera_equipped
	hand_text.visible = not camera_snap.camera_equipped
