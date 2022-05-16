extends State

func enter(from_state: State):
	fsm.next_state = fsm.states.turn

func exit(to_state: State):
	pass

func process(delta):
	pass

