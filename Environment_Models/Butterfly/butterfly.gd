@tool
extends Path3D

const m := 0.1  # increased speed so it's visible

func _ready() -> void:
	$PathFollow3D/Node3D/Butterfly/AnimationPlayer.play("Fly")

func _physics_process(delta: float) -> void:
	$PathFollow3D.progress_ratio += m * delta
