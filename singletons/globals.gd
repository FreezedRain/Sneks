extends Node

onready var SCREEN_SIZE = get_viewport().size

enum Colors {GREEN, RED, YELLOW}
const COLOR_RGB = {Colors.GREEN: Color("#249142"), Colors.RED: Color("#de3526"), Colors.YELLOW: Color("#adab0e")}
const COLOR_LETTERS = {
	'r': Colors.RED, 'g': Colors.GREEN, 'y': Colors.YELLOW,
	'R': Colors.RED, 'G': Colors.GREEN, 'Y': Colors.YELLOW
}

var BIOMES: Dictionary

func load_biomes(holder: Node):
	for biome in holder.get_children():
		BIOMES[biome.biome] = biome
	print(BIOMES)

# var BIOMES = {
# 	LevelData.Biome.DUSTY: BiomeData.new("Dusty", preload("res://tilesets/basic_tileset_dirt.tres"),
# 		"dust_particle", Color(88, 69, 55), Color(174, 140, 114), preload("res://resources/levels/hubs/hub_rocky.tres"),
# 		[preload("res://resources/levels/w1/1-movement.tres"), preload("res://resources/levels/w1/2-slither.tres"),
# 		preload("res://resources/levels/w1/3-turn.tres"), ])
# 	LevelData.Biome.ROCKY: preload("res://resources/biomes/biome_rocky.tres"),
# 	LevelData.Biome.GRASSY: preload("res://resources/biomes/biome_grassy.tres"),
# 	LevelData.Biome.GRAVEYARD: preload("res://resources/biomes/biome_spooky.tres")
# }

const BIOME_ICONS = {
	LevelData.Biome.DUSTY: preload("res://sprites/biome_icons/dusty_icon.png"),
	LevelData.Biome.ROCKY: preload("res://sprites/biome_icons/rocky_icon.png"),
	LevelData.Biome.GRASSY: preload("res://sprites/biome_icons/grassy_icon.png"),
	LevelData.Biome.GRAVEYARD: preload("res://sprites/biome_icons/graveyard_icon.png")
}

# class BiomeData:
# 	var name: String
# 	var tileset: TileSet
# 	var move_particle: String
# 	var color_top: Color
# 	var color_bottom: Color
# 	var hub: Resource
# 	var levels: Array

# 	func _init(name, tileset, move_particle, color_top,
# 		color_bottom, hub, levels):
# 		self.name = name
# 		self.tileset = tileset
# 		self.move_particle = move_particle
# 		self.color_top = color_top
# 		self.color_bottom = color_bottom
# 		self.hub = hub
