extends HBoxContainer

@onready var check_box: CheckBox = $CheckBox


func _on_text_button_pressed() -> void:
	check_box.button_pressed = not check_box.button_pressed 
