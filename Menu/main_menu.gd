extends Control

var MAP_SCENE: PackedScene = preload("res://Environment/game_environment.scn") # Main Scene
#var MAP_SCENE: PackedScene = preload("res://Map/map.tscn") # Test Scene
const GAME_ENVIRONMENT = preload("uid://qy7va4i3kmqt")
var INTRO_SCENE: PackedScene = preload("res://Intro/Intro.tscn") # Intro Scene

#@onready var fade: CanvasLayer = $"../../Fade"
var transitioning := false

func _ready() -> void:
	show()
	$Choices.show()
	$"Back".hide()
	$Settings.hide()
	$HowToPlay.hide()

func _on_start_btn_pressed() -> void:
	if transitioning:
		return
	transitioning = true
	set_process_unhandled_input(false)
	get_viewport().set_input_as_handled() 
	await FadeManager.fade(1.0, 1.5).finished
	get_tree().change_scene_to_packed(INTRO_SCENE)
	await FadeManager.fade(0.0, 1.5).finished
	
	# on video finsihed	 
	#get_tree().change_scene_to_packed(MAP_SCENE) 
	
	hide()
	$Choices.hide()
	$Settings.hide()

func _on_settings_pressed() -> void:
	$Choices.hide()
	$Settings.show()
	$"Back".show()

func _on_how_to_play_pressed() -> void:
	$Choices.hide()
	$HowToPlay.show()
	$"Back".show()

func _on_quit_pressed() -> void:
	get_tree().quit()

func _on_go_back_pressed() -> void:
	$Choices.show()
	$Settings.hide()
	$HowToPlay.hide()
	$"Back".hide()
