extends Node3D

@export var base_wind_speed := 0.5
@export var max_wind_speed := 2.0
@export var gust_strength := 0.08
@export var gust_frequency := 0.2

var time := 0.0
var current_wind_speed := 0.0

@onready var audio = $WindAudio
@onready var particles = $WindParticles

func _process(delta):
	time += delta
	
	var gust = sin(time * gust_frequency * TAU) * gust_strength

	current_wind_speed = base_wind_speed + gust
	current_wind_speed = clamp(current_wind_speed, 0, max_wind_speed)

	RenderingServer.global_shader_parameter_set("wind_speed", current_wind_speed)
	RenderingServer.global_shader_parameter_set("gust_strength", gust_strength)
	RenderingServer.global_shader_parameter_set("gust_frequency", gust_frequency)

	wind_audio()
	wind_particles()

func wind_audio():
	var norm = clamp(current_wind_speed / max_wind_speed, 0.0, 1.0)

	audio.volume_db = lerp(-25, -5, norm)
	audio.pitch_scale = lerp(0.8, 1.2, norm)

func wind_particles():
	var norm = clamp(current_wind_speed / max_wind_speed, 0.0, 1.0)

	particles.amount_ratio = norm
	particles.speed_scale = lerp(0.5, 2.0, norm)
	particles.emitting = norm > 0.05
