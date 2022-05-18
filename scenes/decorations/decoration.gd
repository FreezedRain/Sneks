extends Node2D

export(Array, Texture) var sprites

func _ready():
	$Sprite.texture = sprites[rand_range(0, sprites.size())]
	$Sprite.scale = Vector2.ONE * rand_range(0.5, 1)
	$Sprite.rotation_degrees = rand_range(0, 360)
