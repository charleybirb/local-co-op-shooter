class_name InputManager
extends Node

var mouse_dir : Vector2 = Vector2.ZERO
var parent : CharacterBody3D


func _ready() -> void:
	parent = get_parent()

func _unhandled_input(event: InputEvent) -> void:
	if parent.is_joypad: return
	if not event is InputEventMouseMotion: return
	mouse_dir.x = event.relative.x
	mouse_dir.y = event.relative.y


func get_inputs() -> InputPackage:
	var input : InputPackage = InputPackage.new()
	var joy_index : String = str(parent.joy_index) if parent.joy_index != -1 else ""
	
	var pressable_actions : Array[StringName] = [
		&"jump" + joy_index,
	]
	for action : StringName in pressable_actions:
		if check_pressed_action(action):
			input.pressed_actions.append(action.trim_suffix(joy_index))
	
	var held_actions : Array[StringName] = [
		&"sprint" + joy_index
	]
	for action : StringName in held_actions:
		if check_held_action(action):
			input.held_actions.append(action.trim_suffix(joy_index))
	
	var move_dir : Vector2 = Input.get_vector(
		&"strafe_left" + joy_index, 
		&"strafe_right" + joy_index, 
		&"move_forward" + joy_index, 
		&"move_backward" + joy_index)
	input.move_direction = move_dir
	
	if parent.is_joypad:
		var look_dir : Vector2 = Input.get_vector(
			&"look_left" + joy_index, 
			&"look_right" + joy_index, 
			&"look_up" + joy_index, 
			&"look_down" + joy_index)
		input.look_direction = look_dir
	else:
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
