extends State

var actions: Array
var drags: Array
var current_snake: Snake
var making_turn: bool

func enter(from_state: State):
	pass

func exit(to_state: State):
	pass

func process(delta):
	if Input.is_action_just_pressed("click") and object.hovered_snake != null:
		current_snake = object.hovered_snake
		making_turn = true
		drags.append(len(actions))
	
	if making_turn:
		var direction = convert_direction(object.mouse_grid_pos - current_snake.grid_pos)

		if direction != Vector2.ZERO:
			var action = Actions.SnakeMoveAction.new(current_snake, direction)
			if execute_action(action):
				pass
			
		if Input.is_action_just_released("click"):
			current_snake = null
			making_turn = false
			if drags[len(drags) - 1] - len(actions) == 0:
				drags.pop_back()
	else:
		if Input.is_action_just_pressed("undo"):
			if len(drags) > 0:
				var last_drag = drags.pop_back()
				while len(actions) > last_drag:
					actions.pop_back().undo()

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
