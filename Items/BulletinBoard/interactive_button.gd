extends StaticBody3D

signal on_btn_clicked

func use_object():
	emit_signal("on_btn_clicked")
	# Add Animation or sumn
