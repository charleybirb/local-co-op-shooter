extends PanelContainer


@export var FPS_LABEL : Label
@export var FOV_LABEL : Label

func _physics_process(_delta: float) -> void:
	if FPS_LABEL:
		FPS_LABEL.text = str(Engine.get_frames_per_second())
