extends Node2D

var t = 0
var fade = 1

func _ready():
	pass
	
	
func _process(delta):
	t += delta
	
	if t > 1:
		fade = lerp(fade, 0, 0.1)
		
		$splash.modulate.r = fade;
		$splash.modulate.g = fade;
		$splash.modulate.b = fade;
	
	if t > 2:
		get_tree().change_scene("res://scenes/game/game.tscn")
