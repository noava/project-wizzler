extends CharacterBody3D

var speed
const WALK_SPEED = 5.0
const CROUCH_SPEED = 3.0
const SPRINT_SPEED = 8.0
const JUMP_VELOCITY = 4.0
const SENSITIVITY = 0.004

@onready var terrain = $"../Terrain3D"
@onready var audio = $FootstepAudio

#audio intervals
#have to differentiate sounds between crouch, walk and sprinting/running

var texture_sounds = {
    0: preload("res://Sounds/Material/grass.wav")
}

var footstep_timer := 0.0
var footstep_interval := 0.4

func _physics_process(delta: float) -> void:
    if velocity.length() > 0.1 and is_on_floor():
        footsteps_handle(delta)

func footsteps_handle(delta):
    footstep_timer -= delta
    
    if footstep_timer <= 0.0:
        footstep_timer = footstep_interval
        play_footstep()

func play_footstep():
    if terrain == null:
        return
    
    var terrain_id = terrain.data.get_texture_id(global_position)
    var texture_id = int(terrain_id.x)
    
    print("Terrain ID", texture_id)
    if texture_sounds.has(texture_id):
        #print("has sound", texture_sounds.has(texture_id))
        audio.stream = texture_sounds[texture_id]
        if audio.stream:
            print(audio.stream.resource_path)
        else:
            print("No audio")
        audio.play()

# Crouch
var is_crouching = false
@export_range(5, 10, 0.1) var CROUCH_ANIM_SPEED : float = 7.0

var gravity = 9.8

@onready var head: Node3D = $Head

# When opening the menu
var movement_lock = false

func _process(delta):
    if movement_lock: return

    # Gravity
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Jump
    if Input.is_action_just_pressed("jump") and is_on_floor():
        velocity.y = JUMP_VELOCITY
        
    # Crouch (hold)
    is_crouching = Input.is_action_pressed("crouch")
    
    # Crouch (toggle) Uncomment code below for toggle crouch TODO: Make this as a toggle in settings
    #if Input.is_action_just_pressed("crouch"):
    #	is_crouching = !is_crouching
        
    # Sprint
    if Input.is_action_pressed("sprint") and not is_crouching:
        speed = SPRINT_SPEED
    elif is_crouching:
        speed = CROUCH_SPEED
    else:
        speed = WALK_SPEED
        
    # Movement/Deceleration.
    var input_direction = Input.get_vector("move_left", "move_right", "move_forward", "move_backward")
    var direction = (head.transform.basis * transform.basis * Vector3(input_direction.x, 0, input_direction.y)).normalized()
    
    if is_on_floor():
        if direction:
            velocity.x = direction.x * speed
            velocity.z = direction.z * speed
        else:
            velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
            velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
    else:
        velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
        velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)
    
    move_and_slide()
