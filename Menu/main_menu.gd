extends Control

#var MAP_SCENE: PackedScene = preload("res://Environment/game_environment.scn") # Main Scene
var MAP_SCENE: PackedScene = preload("res://Map/map.tscn") # Test Scene

func _ready() -> void:
	show()
	$Choices.show()
	$"Back".hide()
	$Settings.hide()
	$HowToPlay.hide()


func _on_start_btn_pressed() -> void:
	get_tree().change_scene_to_packed(MAP_SCENE)
	
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
