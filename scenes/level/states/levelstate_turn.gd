extends State

var actions: Array
var snake_idx: int
var making_turn: bool

func enter(from_state: State):
	pass

func exit(to_state: State):
	pass

func process(delta):
	if Input.is_action_just_pressed("click"):
		making_turn = true
	
	if making_turn:
		var direction = convert_direction(object.mouse_grid_pos - object.snakes[snake_idx].grid_pos)

		if Input.is_action_just_released("click"):
			# print(direction)
			# Commit turn
			var action = Actions.SnakeMoveAction.new(object.snakes[snake_idx], direction)

			if execute_action(action):
				snake_idx = (snake_idx + 1) % len(object.snakes)
			
			making_turn = false
	else:
		if Input.is_action_just_pressed("undo"):
			if len(actions) > 0:
				actions.pop_back().undo()
				snake_idx = (snake_idx - 1) % len(object.snakes)

func convert_direction(direction: Vector2) -> Vector2:
	if direction == Vector2.ZERO:
		return Vector2.ZERO
	if abs(direction.x) >= abs(direction.y):
		return Vector2.RIGHT * sign(direction.x)
	else:
		return Vector2.DOWN * sign(direction.y)

func execute_action(action: Actions.Action) -> bool:
	if not action.is_allowed():
		return false
	actions.append(action)
	action.execute()
	return true
