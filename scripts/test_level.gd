extends Node3D

@onready var decal_manager : Node3D = $DecalManager

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("exit"): 
		get_tree().quit()

func add_decal(decal: Decal) -> void:
	decal_manager.add_child(decal)
	if decal_manager.get_child_count() > 10:
		decal_manager.get_child(0).queue_free()
