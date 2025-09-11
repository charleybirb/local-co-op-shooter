extends Node3D

@export var tilt : Node3D
@export var pan : Node3D
@export var camera : Camera3D

const LOOK_SENS : float = 0.06
const MOUSE_SENS : float = 0.003
const BOB_FREQ : float = 2.8
const BOB_AMP : float = 0.086
const BASE_FOV : float = 75.0
const FOV_CHANGE : float = 12.7
const TILT_CLAMP : Vector2 = Vector2(-75.0, 80.0)

var parent : CharacterBody3D
var t_bob : float = 0.0
var input : InputPackage

func _ready() -> void:
	parent = get_parent()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if parent.joypad_index == -1: 
		camera.make_current()


func _physics_process(delta: float) -> void:
	if parent.joypad_index >= 0:
		move_camera(input.look_direction, LOOK_SENS)
	else:
		move_camera(input.mouse_direction, MOUSE_SENS)

	set_camera_effects(delta)
	

func set_input(i: InputPackage) -> void:
	input = i


func move_camera(direction: Vector2, sensitivity: float) -> void:
	if !direction: return
	pan.rotate_y(-direction.x * sensitivity)
	parent.mesh.rotation.y = pan.rotation.y
	tilt.rotate_x(-direction.y * sensitivity)
	tilt.rotation.x = clamp(tilt.rotation.x, deg_to_rad(TILT_CLAMP.x), deg_to_rad(TILT_CLAMP.y))


func set_camera_effects(delta: float) -> void:
	var velocity = parent.velocity
	#Bob the head
	t_bob += delta * velocity.length() * float(parent.is_on_floor())
	camera.transform.origin = _get_headbob(t_bob)
	
	#Set the FOV
	var is_sprinting : bool = &"sprint" in input.held_actions and Vector2(velocity.x, velocity.z).length() > 1.0
	var target_fov : float = BASE_FOV + (FOV_CHANGE * int(is_sprinting))
	camera.fov = lerp(camera.fov, target_fov, delta * 3.4)


func _get_headbob(time: float) -> Vector3:
	var pos : Vector3 = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
