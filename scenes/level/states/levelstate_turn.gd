extends State

const MOVE_DELAY = 0.1
const KEYBOARD_MOVE_DELAY = 0.15

var actions: Array
var drags: Array
var current_snake: Snake
var making_turn: bool
var move_timer: float = 0
var last_drags: int = -1
var selected_snake_idx = 0
var keyboard_controls: bool = false
var last_snake: Snake

func _ready():
	Events.connect("undo_pressed", self, "_on_undo_pressed")
	Events.connect("controls_changed", self, "_on_controls_changed")
	update_undo()

func enter(from_state: State):
	if object.level_data.name.length() > 0:
		object.update_title("%d. %s" % [object.level_data.index + 1, object.level_data.name])

func exit(to_state: State):
	pass

func select_snake(snake):
	current_snake = snake
	current_snake.set_highlight(true)
	last_snake = snake

func deselect_snake():
	if current_snake != null:
		current_snake.set_highlight(false)
		current_snake = null

func process_mouse(delta):
	if Input.is_action_just_pressed("click") and object.hovered_snake != null:
		select_snake(object.hovered_snake)
		making_turn = true
		move_timer = 0
		drags.append(len(actions))
	
	if making_turn:
		if move_timer > 0:
			move_timer -= delta
		else:
			var direction = convert_direction(object.mouse_grid_pos - current_snake.pos)
			process_movement(direction)

		if Input.is_action_just_released("click"):
			deselect_snake()
			making_turn = false
			if drags[len(drags) - 1] - len(actions) == 0:
				drags.pop_back()
			update_undo()
	# else:
	# 	if Input.is_action_just_pressed("undo"):
	# 		undo()

func process_keyboard(delta):
	if not making_turn and Input.is_action_just_pressed("switch"):
		var snakes = object.snake_holder.get_children()
		selected_snake_idx += 1
		if selected_snake_idx > len(snakes) - 1:
			selected_snake_idx = 0
		deselect_snake()
		select_snake(snakes[selected_snake_idx])
	
	var input_x = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var input_y = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	var direction = Vector2(input_x, input_y)
	if input_x != 0:
		direction.y = 0

	if direction != Vector2.ZERO:
		if making_turn:
			if move_timer > 0:
				move_timer -= delta
			else:
				process_movement(direction)
		else:
			making_turn = true
			move_timer = 0
			drags.append(len(actions))
	elif making_turn:
		making_turn = false
		if drags[len(drags) - 1] - len(actions) == 0:
			drags.pop_back()
		update_undo()
	
	# if not making_turn:
	# 	if Input.is_action_just_pressed("undo"):
	# 		undo()

func process(delta):
	if keyboard_controls:
		process_keyboard(delta)
	else:
		process_mouse(delta)

func process_movement(direction):
	# current_snake.override_head_position((object.mouse_pos - current_snake.position).normalized() * 8)
	if direction != Vector2.ZERO:
		var action = Actions.SnakeMoveAction.new(current_snake, direction)
		if execute_action(action):
			move_timer = KEYBOARD_MOVE_DELAY if keyboard_controls else MOVE_DELAY
			end_turn()
		else:
			var head_direction = convert_direction(current_snake.get_direction())
			if current_snake.can_turn_corner(head_direction, direction):
				var forward_action = Actions.SnakeMoveAction.new(current_snake, head_direction)
				if execute_action(forward_action):
					move_timer = KEYBOARD_MOVE_DELAY if keyboard_controls else MOVE_DELAY
					end_turn()

func update_goals():
	for goal in object.goal_holder.get_children():
		var action = goal.update_turn_action()
		if action != null:
			execute_action(action)
	for goal in object.goal_holder.get_children():
		goal.update_turn()

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

func end_turn():
	update_goals()
	check_goals()

func update_undo():
	if last_drags != len(drags):
		Events.emit_signal("undo_remaining", len(drags))
		last_drags = len(drags)

func undo():
	if len(drags) > 0:
		var last_drag = drags.pop_back()
		while len(actions) > last_drag:
			actions.pop_back().undo()
		end_turn()
		update_undo()

func check_goals():
	var all_goals_met = true
	for goal in object.goal_holder.get_children():
		if goal is TransitionGoal:
			all_goals_met = false
			break
		if not goal.active:
			all_goals_met = false
			break
	if all_goals_met:
		fsm.next_state = fsm.states.complete

func _on_undo_pressed():
	if not making_turn:
		undo()

func _on_controls_changed(keyboard):
	keyboard_controls = keyboard
	if keyboard_controls:
		selected_snake_idx = 0
		var snakes = object.snake_holder.get_children()
		if last_snake != null:
			selected_snake_idx = snakes.find(last_snake)
		select_snake(snakes[selected_snake_idx])
	else:
		selected_snake_idx = 0
		deselect_snake()
		if object.hovered_snake != null:
			select_snake(object.hovered_snake)
			making_turn = true
			move_timer = 0
			drags.append(len(actions))

