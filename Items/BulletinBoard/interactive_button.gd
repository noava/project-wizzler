extends StaticBody3D

signal on_btn_clicked

func use_object():
	emit_signal("on_btn_clicked")
	position.x = -0.03
	await get_tree().create_timer(0.1).timeout
	position.x = 0
