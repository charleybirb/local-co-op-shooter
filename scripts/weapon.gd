extends Node3D

@export var raycast : RayCast3D
@export var decal_scene : PackedScene


@onready var anim_player : AnimationPlayer = $MeshInstance3D/AnimationPlayer

var decals : Array[Decal] = []

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed(&"shoot") and not anim_player.is_playing():
		shoot()


func shoot() -> void:
	anim_player.play(&"shoot")
	if not raycast.get_collider(): return
	var collider : Node3D = raycast.get_collider()
	var col_point : Vector3 = raycast.get_collision_point()
	var col_normal : Vector3 = raycast.get_collision_normal()
	var new_decal : Decal = decal_scene.instantiate()
	collider.add_child(new_decal)
	new_decal.global_transform.origin = col_point
	new_decal.look_at(col_normal, col_normal)
	decals.append(new_decal)
	if decals.size() > 10: decals.pop_front().queue_free()
	
