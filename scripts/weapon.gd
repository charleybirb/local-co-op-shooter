extends Node3D

@export var raycast : RayCast3D
@export var decal_scene : PackedScene
@export var power : int = 5

@export var player : CharacterBody3D

@onready var sfx : AudioStreamPlayer = $AudioStreamPlayer
@onready var anim_player : AnimationPlayer = $MeshInstance3D/AnimationPlayer

var joypad_index : int

func _ready() -> void:
	joypad_index = player.joypad_index


func _physics_process(_delta: float) -> void:
	var action_suffix = str(joypad_index) if joypad_index != -1 else ""
	if Input.is_action_just_pressed(&"shoot" + action_suffix) and not anim_player.is_playing():
		shoot()


func shoot() -> void:
	anim_player.play(&"shoot")
	sfx.play()
	
	if not raycast.get_collider(): return
	
	var collider : Node3D = raycast.get_collider()
	if not collider is CharacterBody3D:
		create_decal()

	
	if collider.has_user_signal(&"damage_taken"):
		collider.emit_signal(&"damage_taken", power)
	

func create_decal() -> void:
	var col_point : Vector3 = raycast.get_collision_point()
	var col_normal : Vector3 = raycast.get_collision_normal()
	var new_decal : Decal = decal_scene.instantiate()
	
	player.get_parent().add_decal(new_decal)
	new_decal.global_transform.origin = col_point
	
	var up_vector : Vector3 = Vector3.UP if col_normal != Vector3.UP else Vector3.RIGHT
	var look_vector : Vector3 = col_point + col_normal
	new_decal.look_at(look_vector, up_vector)
	new_decal.rotation.x -= PI/2
	#when the col_normal is pointing straight down, the look_vector and up_vector are parallel? idk
	
	
	
	
