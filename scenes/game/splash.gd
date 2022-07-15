extends CanvasLayer

onready var cmg_splash = $Control/CoolmathSplash
onready var icedrop_splash = $Control/IcedropSplash

var t = 0
var fade = 1
var fade_in = 0

func _ready():
	Globals.INITIAL_RESOLUTION = get_viewport().size
	
func _process(delta):
	t += delta
	
	if t > 1 && t < 1.5:
		fade = lerp(fade, 0, delta * 12)
		
		cmg_splash.modulate.a = fade;
		
	if t > 1.5 && t < 2.5:
		fade_in = lerp(fade_in, 1, delta * 12)
		
		cmg_splash.visible = false;
		icedrop_splash.visible = true;
		
		icedrop_splash.modulate.a = fade_in;
	
	if t > 2.5:
		fade_in = lerp(fade_in, 0, delta * 12)
		
		icedrop_splash.modulate.a = fade_in;
		
	if t > 3:
		get_tree().change_scene("res://scenes/game/game.tscn")
