extends AnimatableBody3D

@export var area : Area3D
@export var top_position : Vector3
@export var bottom_position : Vector3

const SPEED : float = 2.5

var is_going_up : bool = false

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		is_going_up = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("players"):
		is_going_up = false


func _ready() -> void:
	area.connect(&"body_entered", _on_body_entered)
	area.connect(&"body_exited", _on_body_exited)
	position = bottom_position
	
	
func _physics_process(delta: float) -> void:
	if is_going_up:
		if position.y <= top_position.y:
			position.y += SPEED * delta
	else:
		if position.y >= bottom_position.y:
			position.y -= SPEED * delta
