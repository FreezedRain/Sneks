extends Node

onready var SCREEN_SIZE = get_viewport().size

enum Colors {GREEN, RED, YELLOW}
const COLOR_RGB = {Colors.GREEN: Color("#249142"), Colors.RED: Color("#de3526"), Colors.YELLOW: Color("#adab0e")}
const COLOR_LETTERS = {
	'r': Colors.RED, 'g': Colors.GREEN, 'y': Colors.YELLOW,
	'R': Colors.RED, 'G': Colors.GREEN, 'Y': Colors.YELLOW
}

var BIOMES: Dictionary
var LEVELS: Dictionary

func load_biomes(holder: Node):
	for biome in holder.get_children():
		BIOMES[biome.biome] = biome
	load_levels()

func load_levels():
	for biome_id in BIOMES:
		var biome = BIOMES[biome_id]
		for level_idx in range(len(biome.levels)):
			var level = biome.levels[level_idx]
			level.index = level_idx
			LEVELS[level.get_id()] = level
		biome.hub.index = -1
		LEVELS[biome.hub.get_id()] = biome.hub