extends Sprite

var grid_pos: Vector2
var target_position: Vector2

func _process(delta):
	position = lerp(position, target_position, delta * 12)

func align_to_grid(grid: Grid, instant: bool = false):
	target_position = grid.grid_to_world(grid_pos)
	if instant:
		position = target_position