extends State

const MOVE_DELAY = 0.1

var actions: Array
var drags: Array
var current_snake: Snake
var making_turn: bool
var move_timer: float = 0
var last_drags: int = -1

func _ready():
	Events.connect("undo_pressed", self, "_on_undo_pressed")
	update_undo()

func enter(from_state: State):
	if object.level_data.name.length() > 0:
		object.update_title("%d. %s" % [object.level_data.index + 1, object.level_data.name])

func exit(to_state: State):
	pass

func process(delta):
	if Input.is_action_just_pressed("click") and object.hovered_snake != null:
		current_snake = object.hovered_snake
		current_snake.set_highlight(true)
		# current_snake.z_index = 1
		making_turn = true
		move_timer = 0
		drags.append(len(actions))
	
	if making_turn:
		if move_timer > 0:
			move_timer -= delta
		else:
			process_movement()

		if Input.is_action_just_released("click"):
			current_snake.set_highlight(false)
			# current_snake.z_index = 0
			current_snake = null
			making_turn = false
			if drags[len(drags) - 1] - len(actions) == 0:
				drags.pop_back()
			update_undo()
	else:
		if Input.is_action_just_pressed("undo"):
			undo()

func process_movement():
	var direction = convert_direction(object.mouse_grid_pos - current_snake.pos)
	# current_snake.override_head_position((object.mouse_pos - current_snake.position).normalized() * 8)
	if direction != Vector2.ZERO:
		var action = Actions.SnakeMoveAction.new(current_snake, direction)
		if execute_action(action):
			move_timer = MOVE_DELAY
			end_turn()
		else:
			var head_direction = convert_direction(current_snake.get_direction())
			if current_snake.can_turn_corner(head_direction, direction):
				var forward_action = Actions.SnakeMoveAction.new(current_snake, head_direction)
				if execute_action(forward_action):
					move_timer = MOVE_DELAY
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