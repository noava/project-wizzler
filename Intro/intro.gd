extends Node2D

var MAP_SCENE: PackedScene = preload("res://Environment/game_environment.scn") # Main Scene
@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN) 
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_video_stream_player_finished() -> void:
	get_tree().change_scene_to_packed(MAP_SCENE) 
