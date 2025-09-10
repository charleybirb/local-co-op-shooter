extends Node

@export var max_health : int = 10
@export var defense : int = 1
var current_health : int = max_health


func _ready() -> void:
	get_parent().add_user_signal("damage_taken", [{"name": "dmg"}, {"type": TYPE_INT}])
	get_parent().connect(&"damage_taken", take_damage)


func take_damage(dmg: int) -> void:
	var total_dmg : int = dmg - defense
	if total_dmg < 0: total_dmg = 0
	current_health -= total_dmg
	if current_health <= 0:
		die()
	
	
func die() -> void:
	get_parent().queue_free()
