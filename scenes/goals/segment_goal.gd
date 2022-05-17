class_name SegmentGoal extends GridObject

var color
var active: bool = false
# var sprite: Sprite

func _ready():
	Events.connect("turn_updated", self, "_on_turn_updated")

func set_color(color):
	self.color = color
	modulate = Globals.COLORS_RGB[self.color]

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
	for obj in tile_objects:
		if obj is SnakeSegment:
			now_active = obj.color == color
		# elif obj is SnakeSegment:
		# 	now_active = obj.snake.color == color
	if now_active != active:
		set_active(now_active)
