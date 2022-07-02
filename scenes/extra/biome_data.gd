class_name BiomeData extends Node

export (LevelData.Biome) var biome
export (TileSet) var tileset
export (String) var move_particle
export (Color) var color_top
export (Color) var color_bottom
export (Texture) var icon
export (Resource) var hub
export (int) var next_levels_required
export (Array, Resource) var levels

func can_unlock_next() -> bool:
	return total_levels_complete() >= next_levels_required

func total_levels_complete() -> int:
	var count = 0
	for level in levels:
		if SaveManager.is_level_complete(level.get_id()):
			count += 1
	return count

func get_level(idx: int) -> LevelData:
	if idx == -1:
		return hub
	return levels[idx]