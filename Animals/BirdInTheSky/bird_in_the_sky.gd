extends Node3D

@onready var animation_player: AnimationPlayer = $birds/AnimationPlayer

@export var speed: float = 0.6

func _ready() -> void:
	animation_player.play("Scene")

func _process(delta: float) -> void:
	self.rotate_y(0.1 * delta)
	pass
