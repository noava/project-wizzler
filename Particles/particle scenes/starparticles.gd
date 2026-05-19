extends Node2D

@onready var emitters = [$StarRight,$StarLeft]

func snapping_star():
	for n in emitters:
		n.restart()
		n.emitting = true
		
func play_starparticles():
	snapping_star()
	await get_tree().create_timer(1.0).timeout
	queue_free()
