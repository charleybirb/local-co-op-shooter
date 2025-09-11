extends Node

@export var max_health : int = 10
@export var defense : int = 0
@export var mesh : MeshInstance3D

var current_health : int = max_health
var parent : Node3D


func _ready() -> void:
	parent = get_parent()
	current_health = max_health
	parent.add_user_signal("damage_taken", [{"name": "dmg", "type": TYPE_INT}])
	parent.connect(&"damage_taken", take_damage)


func take_damage(dmg: int) -> void:
	var total_dmg : int = dmg - defense
	if total_dmg < 0: total_dmg = 0
	current_health -= total_dmg
	
	#mesh.get_active_material(0).albedo_color = Color("ff0000")
	mesh.scale = Vector3(1.1, 1.1, 1.1)
	await get_tree().create_timer(0.1).timeout
	#mesh.get_active_material(0).albedo_color = Color("ffffff")
	mesh.scale = Vector3(1.0, 1.0, 1.0)
	
	if current_health <= 0:
		die()
	
	
func die() -> void:
	await get_tree().create_timer(0.1).timeout
	parent.queue_free()
