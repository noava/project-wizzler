extends WorldEnvironment

@export var rotation_speed = 0.005 # Adjust for speed

func _process(delta):
	# Rotate the sky around the Y-axis
	environment.sky_rotation.y += rotation_speed * delta
