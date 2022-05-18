extends Node2D

const DECORATION_SCENE = preload("res://scenes/decorations/Decoration.tscn")

func setup():
	
	for i in range(-1, Grid.size.x + 1):
		for j in range(-1, Grid.size.y + 1):
			
			if Grid.is_wall(Vector2(i, j)):
				
				if rand_range(0,3) <= 1:
				
					var decor = DECORATION_SCENE.instance()
					add_child(decor)
					decor.position = Grid.grid_to_world(Vector2(i, j))
