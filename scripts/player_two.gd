extends CharacterBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5

var joypad_index = 1

func _ready() -> void:
	if Input.get_connected_joypads().size() == 1:
		


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
