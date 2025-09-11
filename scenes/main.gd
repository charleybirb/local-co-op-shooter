extends Control

@export var level : Node3D 

var player_one
var player_two

@onready var camera_one : Camera3D = $VBoxContainer/SubViewportContainer/PlayerOneViewport/Camera3D
@onready var camera_two : Camera3D = $VBoxContainer/SubViewportContainer2/PlayerTwoViewport/Camera3D2


func _ready() -> void:
	var players : Array[CharacterBody3D]
	for child : Node in level.get_children():
		if child.is_in_group(&"players"): 
			players.append(child)
	
	player_one = players[0]
	player_two = players[1]
	player_one.reticle.visible = false
	player_two.reticle.visible = false


func _process(_delta: float) -> void:
	position_camera(camera_one, player_one)
	position_camera(camera_two, player_two)


func position_camera(camera: Camera3D, player: CharacterBody3D) -> void:
	camera.global_position = player.head.camera.global_position
	camera.global_rotation = player.head.camera.global_rotation
