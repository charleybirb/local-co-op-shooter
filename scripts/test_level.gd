extends Node3D

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action("exit"): 
		get_tree().quit()
