extends Node

onready var SCREEN_SIZE = get_viewport().size

enum Colors {GREEN, RED, YELLOW}
const COLOR_RGB = {Colors.GREEN: Color("#249142"), Colors.RED: Color("#de3526"), Colors.YELLOW: Color("#adab0e")}
const COLOR_LETTERS = {
	'r': Colors.RED, 'g': Colors.GREEN, 'y': Colors.YELLOW,
	'R': Colors.RED, 'G': Colors.GREEN, 'Y': Colors.YELLOW
}

const BIOME_RESOURCES = {
	LevelData.Biome.DUSTY: preload("res://resources/biomes/biome_dusty.tres"),
	LevelData.Biome.GRASSY: preload("res://resources/biomes/biome_grassy.tres"),
	LevelData.Biome.ROCKY: preload("res://resources/biomes/biome_rocky.tres")
}
