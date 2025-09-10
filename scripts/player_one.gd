extends CharacterBody3D

const WALK_SPEED : float = 5.0
const SPRINT_SPEED : float = 7.5 
const JUMP_VELOCITY : float = 5.5
const LOOK_SENS : float = 0.06
const MOUSE_SENS : float = 0.003
const TILT_CLAMP : Vector2 = Vector2(-75.0, 80.0)
const BOB_FREQ : float = 2.0
const BOB_AMP : float = 0.08
const BASE_FOV : float = 75.0
const FOV_CHANGE : float = 11.6

const JUMP_BUFFER : float = 0.155
const COYOTE_BUFFER : float = 0.187

@export var head : Node3D
@export var tilt : Node3D
@export var pan : Node3D
@export var camera : Camera3D
@export var input_manager : InputManager

var speed : float = WALK_SPEED
var t_bob : float = 0.0
var is_gamepad : bool = false

var jump_time_pressed : float = 0.0
var coyote_time : float = 0.0


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta: float) -> void:
	var input : InputPackage = input_manager.get_inputs()
	
	if Input.is_action_just_pressed(&"switch_input_type"):
		is_gamepad = !is_gamepad
	
	if is_gamepad:
		move_camera(input.look_direction, LOOK_SENS)
	else:
		move_camera(input.mouse_direction, MOUSE_SENS)
	
	apply_gravity(delta)
	check_jump(delta, input)
	apply_velocity(delta, input)
	set_camera_effects(delta, input)
	
	move_and_slide()
	
	input.queue_free()


func check_jump(delta: float, input: InputPackage) -> void:
	if not is_on_floor() and coyote_time == 0.0:
		coyote_time += delta
	
	
	if coyote_time > 0.0:
		coyote_time += delta
		if coyote_time < COYOTE_BUFFER:
			if &"jump" in input.pressed_actions:
				jump()
	
	if is_on_floor():
		coyote_time = 0.0
	
	print(coyote_time)

	if jump_time_pressed > 0.0:
		jump_time_pressed += delta
		if jump_time_pressed < JUMP_BUFFER:
			if is_on_floor():
				jump()
				jump_time_pressed = 0.0
		else:
			jump_time_pressed = 0.0
	
	if &"jump" in input.pressed_actions and jump_time_pressed == 0.0:
		jump_time_pressed += delta


func jump() -> void:
	velocity.y += JUMP_VELOCITY


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta


func apply_velocity(delta: float, input: InputPackage) -> void:
	var input_dir := input.move_direction
	var direction := (pan.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_on_floor():
		if direction:
			speed = SPRINT_SPEED if &"sprint" in input.held_actions else WALK_SPEED
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 2.5)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 2.5)


func move_camera(direction: Vector2, sensitivity: float) -> void:
	if !direction: return
	pan.rotate_y(-direction.x * sensitivity)
	tilt.rotate_x(-direction.y * sensitivity)
	tilt.rotation.x = clamp(tilt.rotation.x, deg_to_rad(TILT_CLAMP.x), deg_to_rad(TILT_CLAMP.y))


func set_camera_effects(delta: float, input: InputPackage) -> void:
	#Bob the head
	t_bob += delta * velocity.length() * float(is_on_floor())
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
