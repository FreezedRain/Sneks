extends State

const MOVE_DELAY = 0.1

var actions: Array
var drags: Array
var current_snake: Snake
var making_turn: bool
var move_timer: float = 0

func _ready():
	Events.connect("turn_updated", self, "_on_turn_updated")
	Events.connect("post_turn_updated", self, "_on_post_turn_updated")

func enter(from_state: State):
	Events.emit_signal("turn_updated")

func exit(to_state: State):
	pass

func process(delta):
	if Input.is_action_just_pressed("click") and object.hovered_snake != null:
		current_snake = object.hovered_snake
		current_snake.set_highlight(true)
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
				Events.emit_signal("turn_updated")
				Events.emit_signal("post_turn_updated")

func process_movement():
	var direction = convert_direction(object.mouse_grid_pos - current_snake.grid_pos)
	if direction != Vector2.ZERO:
		var action = Actions.SnakeMoveAction.new(current_snake, direction)
		if execute_action(action):
			move_timer = MOVE_DELAY

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
	Events.emit_signal("turn_updated")
	Events.emit_signal("post_turn_updated")
	return true

func _on_turn_updated():
	pass

func _on_post_turn_updated():
	var all_goals_met = true
	for obj in object.grid.objects:
		if obj is SnakeGoal and not obj.active:
			all_goals_met = false
			break
		if obj is SegmentGoal and not obj.active:
			all_goals_met = false
			break
		if obj is ClearGoal and not obj.active:
			all_goals_met = false
			break
	if all_goals_met:
		fsm.next_state = fsm.states.complete
