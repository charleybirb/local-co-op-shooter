class_name InputManager
extends Node

var mouse_dir : Vector2 = Vector2.ZERO

func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion: return
	mouse_dir.x = event.relative.x
	mouse_dir.y = event.relative.y
	#pan.rotate_y(-event.relative.x * LOOK_SENS)
	#tilt.rotate_x(-event.relative.y * LOOK_SENS)
	#tilt.rotation.x = clamp(tilt.rotation.x, deg_to_rad(TILT_CLAMP.x), deg_to_rad(TILT_CLAMP.y))


func get_inputs() -> InputPackage:
	var input : InputPackage = InputPackage.new()
	
	var pressable_actions : Array[StringName] = [
		&"jump",
	]
	for action : StringName in pressable_actions:
		if check_pressed_action(action):
			input.pressed_actions.append(action)
	
	var held_actions : Array[StringName] = [
		&"sprint"
	]
	for action : StringName in held_actions:
		if check_held_action(action):
			input.held_actions.append(action)
	
	var move_dir : Vector2 = Input.get_vector(&"strafe_left", &"strafe_right", &"move_forward", &"move_backward")
	input.move_direction = move_dir
	
	var look_dir : Vector2 = Input.get_vector(&"look_left", &"look_right", &"look_up", &"look_down")
	input.look_direction = look_dir
	
	input.mouse_direction = mouse_dir
	mouse_dir = Vector2.ZERO
	
	return input


func check_pressed_action(action: StringName) -> bool:
	if Input.is_action_just_pressed(action):
		return true
	return false

func check_held_action(action: StringName) -> bool:
	if Input.is_action_pressed(action):
		return true
	return false
