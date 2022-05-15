## Everything related to a single level
extends Node2D

onready var tiles = $Tiles
onready var snakes = $Snakes.get_children()

# Handle player turns and environment actions