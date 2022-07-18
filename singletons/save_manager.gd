extends Node

var USE_SAVES = OS.has_feature("standalone")

const SAVE_FOLDER : String = "user://"
const SAVE_NAME : String = "save.tres"

var current_save : GameSave

func _ready():
	Events.connect("level_completed", self, "_on_level_completed")
	load_game()

func save_game():
	if not USE_SAVES:
		return
	if current_save == null:
		current_save = GameSave.new()
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME)
	var error : int = ResourceSaver.save(save_path, current_save)
	if error != OK:
		print('Error saving game!')
		return
	print('Saved.')

func load_game():
	if not USE_SAVES:
		current_save = GameSave.new()
		return
	var save_file_path : String = SAVE_FOLDER.plus_file(SAVE_NAME)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file doesn't exist!")
		save_game()
		return
	current_save = load(save_file_path)
	print('Loaded.')

func get_last_level() -> String:
	return current_save.last_level_id

func is_level_complete(level_id) -> bool:
	return current_save.completed_levels.has(level_id)

func complete_level(level_id):
	if not current_save.completed_levels.has(level_id):
		current_save.completed_levels.append(level_id)
		save_game()

func complete_all_levels():
	for biome_id in Globals.BIOMES:
		var biome = Globals.BIOMES[biome_id]
		for level in biome.levels:
			var level_id = level.get_id()
			if not current_save.completed_levels.has(level_id):
				current_save.completed_levels.append(level_id)
		if not current_save.completed_levels.has(biome.hub.get_id()):
				current_save.completed_levels.append(biome.hub.get_id())
	save_game()
	Globals.game.restart_level()

func set_last_level(level_id):
	current_save.last_level_id = level_id
	save_game()

func _on_level_completed(level_id):
	complete_level(level_id)
	var level_data = Globals.LEVELS[level_id]
	if Globals.BIOMES[level_data.biome].can_unlock_next() and level_data.biome < len(Globals.BIOMES) - 1:
		complete_level(Globals.BIOMES[level_data.biome + 1].hub.get_id())
