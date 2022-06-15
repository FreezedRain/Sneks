extends Node

const SAVE_FOLDER : String = "user://"
const SAVE_NAME : String = "save.tres"

var current_save : GameSave

func _ready():
	Events.connect("level_completed", self, "_on_level_completed")
	load_game()

func save_game():
	print('Saving game...')
	if current_save == null:
		current_save = GameSave.new()
	var save_path = SAVE_FOLDER.plus_file(SAVE_NAME)
	var error : int = ResourceSaver.save(save_path, current_save)
	if error != OK:
		print('Error saving game!')
		return
	print('Saved.')

func load_game():
	print('Loading save file...')
	var save_file_path : String = SAVE_FOLDER.plus_file(SAVE_NAME)
	var file : File = File.new()
	if not file.file_exists(save_file_path):
		print("Save file doesn't exist!")
		save_game()
		return
	current_save = load(save_file_path)
	print('Loaded.')

func is_level_complete(level_id) -> bool:
	return current_save.completed_levels.has(level_id)

func complete_level(level_id):
	if not current_save.completed_levels.has(level_id):
		current_save.completed_levels.append(level_id)
		save_game()

func _on_level_completed(level_id):
	complete_level(level_id)
