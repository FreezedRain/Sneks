extends Node

var finished: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	VisualServer.set_default_clear_color(Color.black)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("click") and finished:
		Events.emit_signal("return_to_game")

func _on_AnimationPlayer_animation_finished(anim_name:String):
	finished = true
