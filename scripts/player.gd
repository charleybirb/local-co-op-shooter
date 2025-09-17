extends CharacterBody3D

const WALK_SPEED : float = 5.0
const SPRINT_SPEED : float = 7.5 
const JUMP_VELOCITY : float = 5.5
const JUMP_BUFFER : float = 0.155
const COYOTE_BUFFER : float = 0.187

@export var input_manager : InputManager
@export var joypad_index : int
@export var head : Node3D
@export var mesh : MeshInstance3D
@export var reticle : CanvasLayer
@export var weapon : Node3D

var speed : float = WALK_SPEED

var jump_time_pressed : float = 0.0
var coyote_time : float = 0.0
var gravity : Vector3 = Vector3(0.0, -12.2, 0.0)

func _ready() -> void:
	add_to_group(&"players")
	
	#match camera and mesh rotation to player rotation in editor
	mesh.rotation.y = rotation.y
	head.pan.rotation.y = rotation.y
	rotation.y = 0.0


func _physics_process(delta: float) -> void:
	var input : InputPackage = input_manager.get_inputs()
	head.set_input(input)
	
	var is_grounded : bool = is_on_floor()
	if not is_grounded: 
		apply_gravity(delta)
	check_jump(delta, is_grounded, input)
	apply_velocity(delta, is_grounded, input)
	move_and_slide()
	
	input.queue_free()


func check_jump(delta: float, is_grounded: bool, input: InputPackage) -> void:
	if coyote_time > 0.0:
		coyote_time += delta
		if coyote_time < COYOTE_BUFFER:
			if &"jump" in input.pressed_actions:
				jump()
	
	if is_grounded:
		coyote_time = 0.0

	if jump_time_pressed > 0.0:
		jump_time_pressed += delta
		if jump_time_pressed < JUMP_BUFFER:
			if is_grounded:
				jump()
				jump_time_pressed = 0.0
		else:
			jump_time_pressed = 0.0
	
	if not is_grounded and coyote_time == 0.0:
		coyote_time += delta

	if &"jump" in input.pressed_actions and jump_time_pressed == 0.0:
		jump_time_pressed += delta


func jump() -> void:
	velocity.y += JUMP_VELOCITY


func apply_gravity(delta: float) -> void:
	var _gravity : Vector3 = gravity
	velocity += _gravity * delta
		

func apply_velocity(delta: float, is_grounded: bool, input: InputPackage) -> void:
	var input_dir := input.move_direction
	var direction : Vector3 = (head.pan.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if is_grounded:
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


func equip_weapon() -> void:
	weapon.equip()
