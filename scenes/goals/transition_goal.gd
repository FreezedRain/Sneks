extends Goal

var level_idx: int setget set_level_idx

# func _ready():
	# Events.connect("level_transition", self, "_on_test")

func set_level_idx(value: int):
	level_idx = value
	$Label.text = str(value)

func update_turn():
	var tile_objects = Grid.get_tile(pos).objects
	for obj in tile_objects:
		if obj is Snake:
			Events.emit_signal("level_transition", level_idx)

# func _on_test(idx):
# 	print(idx)
