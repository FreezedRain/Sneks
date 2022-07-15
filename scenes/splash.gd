extends Node2D

var t = 0
var fade = 1
var fade_in = 0

func _ready():
	pass
	
	
func _process(delta):
	t += delta
	
	if t > 1 && t < 1.5:
		fade = lerp(fade, 0, 0.1)
		
		$splash.modulate.a = fade;
		
	if t > 1.5 && t < 2.5:
		fade_in = lerp(fade_in, 1, 0.1)
		
		$splash.visible = false;
		$Icedrop.visible = true;
		
		$Icedrop.modulate.a = fade_in;
	
	if t > 2.5:
		fade_in = lerp(fade_in, 0, 0.1)
		
		$Icedrop.modulate.a = fade_in;
		
	if t > 3:
		get_tree().change_scene("res://scenes/game/game.tscn")
