extends Control

var is_menu: bool = false

@onready var player: CharacterBody3D = $"../.."
@onready var fps_label: Label = $"../FPSLabel"
@onready var inv_keybinds: Control = player.get_node("HUD/InvKeybinds")

func _ready() -> void:
	fps_label.visible = false

	hide()
	$Settings.hide()
	$AreYouSure.hide()

func _unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("esc"):
		if !is_menu:
			open_menu()
		else:
			_on_resume_pressed()

func _physics_process(_delta: float) -> void:
	if fps_label.visible:
		fps_label.text = "FPS: " + str(int(Engine.get_frames_per_second()))

func open_menu():
	show()
	$Choices.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	is_menu = true

	player.get_node("Head").mouse_lock = false
	player.movement_lock = true

func _on_resume_pressed() -> void:
	hide()
	$Choices.hide()
	$Settings.hide()
	$AreYouSure.hide()
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	player.get_node("Head").mouse_lock = true
	player.movement_lock = false
	is_menu = false


func _on_settings_pressed() -> void:
	$Choices.hide()
	$Settings.show()


func _on_leave_pressed() -> void:
	$Choices.hide()
	$AreYouSure.show()


# Option menu
func _on_fullscreen_pressed(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _on_fps_button_pressed(toggled_on: bool) -> void:
	fps_label.visible = toggled_on

func _on_go_back_pressed() -> void:
	$Choices.show()
	$Settings.hide()


# Secondary Menu (Are you sure?)
func _on_no_button_pressed() -> void:
	$Choices.show()
	$AreYouSure.hide()

func _on_yes_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu/main_menu.tscn")


func _on_inv_keybinds_pressed(toggled_on: bool) -> void:
	inv_keybinds.visible = toggled_on
