extends Node

var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _input(event):
	if not finished:
		return
	if (event is InputEventKey or event is InputEventJoypadButton or event is InputEventMouseButton) and event.pressed:
		finished = false
		Events.emit_signal("return_to_game")

func _on_AnimationPlayer_animation_finished(anim_name:String):
	finished = true
