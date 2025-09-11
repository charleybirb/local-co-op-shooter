extends Area3D
@export var type : StringName

func _on_body_entered(body: Node3D) -> void:
	if not body.is_in_group(&"players"): return
	if type == &"weapon":
		body.enable_weapon()
		queue_free()


func _ready() -> void:
	body_entered.connect(_on_body_entered)
