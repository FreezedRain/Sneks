class_name ClearGoal extends GridObject

var color
var active: bool = false
# var sprite: Sprite

func _ready():
	Events.connect("turn_updated", self, "_on_turn_updated")

func set_active(active):
	self.active = active
	return
	if active:
		hide()
	else:
		show()

func _on_turn_updated():
	var tile_objects = grid.get_tile(grid_pos).objects
	var now_active = false
	if tile_objects.size() == 0:
		now_active = true
	if now_active != active:
		set_active(now_active)
