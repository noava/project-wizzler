extends Node2D

var MAP_SCENE: PackedScene = preload("res://Environment/game_environment.scn") # Main Scene
@onready var video_stream_player: VideoStreamPlayer = $Control/VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	

func _on_video_stream_player_finished() -> void:
	
	await FadeManager.fade(1.0, 1).finished
	get_tree().change_scene_to_packed(MAP_SCENE)

	
