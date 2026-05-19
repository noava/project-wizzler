extends Control

#var MAP_SCENE: PackedScene = preload("res://Map/map.tscn") # Test Scene
var INTRO_SCENE: PackedScene = preload("res://Intro/Intro.tscn") # Intro Scene

var transitioning := false

func _ready() -> void:
	show()
	$Choices.show()
	$"Back".hide()
	$Settings.hide()
	$HowToPlay.hide()

func _on_start_btn_pressed() -> void:
	# Reset Globals
	Global.imagesTaken = []
	Global.animals_found = []
	Global.camera_in_inv = false

	# Show video
	if transitioning:
		return
	transitioning = true
	set_process_unhandled_input(false)
	get_viewport().set_input_as_handled() 
	await FadeManager.fade(1.0, 1.5).finished
	get_tree().change_scene_to_packed(INTRO_SCENE)
	await FadeManager.fade(0.0, 1.5).finished
	
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
