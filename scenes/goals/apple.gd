class_name Apple extends Goal

func _on_set_active():
	if active:
		ParticleManager.spawn('apple_particle', position)
		hide()
	else:
		show()

var startpos
var t = 0

func _ready():
	startpos = $Apple.position

func _process(delta):
	
	t += delta
	$Apple.position = startpos + Vector2.UP * sin(t*2) * 3;
	
