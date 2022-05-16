## Everything related to a single level
class_name Level extends Node2D

const SNAKE_SCENE = preload("res://scenes/actors/snake/snake.tscn")

# onready var fsm = StateMachine.new(self, $States, $States/idle, false)
onready var grid = $Grid
onready var snake_holder = $Snakes

# Data
var level_data: LevelData
var snakes: Array
var actions: Array

# Turn
var snake_idx: int
var waiting_for_turn: bool
var making_turn: bool

# Input
var mouse_pos: Vector2
var mouse_grid_pos: Vector2

func _ready():
	pass

func load_level(level_data: LevelData):
	level_data.parse()
	self.level_data = level_data

	grid.load_data(level_data)

	for snake_segments in level_data.snakes:
		var snake = SNAKE_SCENE.instance()
		snake.setup(grid)
		snake.setup_segments(snake_segments)
		snake_holder.add_child(snake)
		snakes.append(snake)

func _process(delta):
	if Input.is_action_just_pressed("ui_up"):
		snakes[0].move(Vector2.UP)
	if Input.is_action_just_pressed("ui_down"):
		snakes[0].move(Vector2.DOWN)
	if Input.is_action_just_pressed("ui_right"):
		snakes[0].move(Vector2.RIGHT)
	if Input.is_action_just_pressed("ui_left"):
		snakes[0].move(Vector2.LEFT)
	# fsm.process(delta)

# func process_input():
# 	mouse_pos = get_viewport().get_mouse_position()
# 	mouse_grid_pos = grid.world_to_grid(mouse_pos)

# func process_turns():
# 	if Input.is_action_just_pressed("click"):
# 		making_turn = true
# 	if making_turn:
# 		var direction = (mouse_grid_pos - snakes[snake_idx].grid_pos)


# 		if Input.is_action_just_released("click"):
# 			var action = Actions.MoveAction.new(snakes[snake_idx], direction)
# 			if is_action_possible(action):
# 				# Commit turn
# 				if execute_action(action):
# 					# Did we win/lose?
# 					pass
# 				waiting_for_turn = true
# 			else:
# 				waiting_for_turn = false
# 			making_turn = false

# func start_turn():
# 	waiting_for_turn = true

# func end_turn():
# 	snake_idx = (snake_idx + 1) % len(snakes)

# func is_action_possible(action: Actions.Action) -> bool:
# 	if action.direction == Vector2.ZERO:
# 		return false
# 	return true

# func execute_action(action: Actions.Action) -> bool:
# 	actions.append(action)
# 	if action is Actions.MoveAction:
# 		action.execute()
# 		return true
# 	return false
