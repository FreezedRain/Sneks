class_name BiomeData extends Node

export (LevelData.Biome) var biome
export (TileSet) var tileset
export (String) var move_particle
export (Color) var color_top
export (Color) var color_bottom
export (Texture) var icon
export (Resource) var hub
export (Array, Resource) var levels

func get_level(idx: int) -> LevelData:
	if idx == -1:
		return hub
	return levels[idx]