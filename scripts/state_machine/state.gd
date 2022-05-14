## State class for the state_machine.gd
class_name State extends Node

var fsm
var object : Node

func setup(fsm, object):
	self.fsm = fsm
	self.object = object
	post_setup()

func post_setup():
	pass

func enter(from_state : State) -> void:
	pass

func exit(to_state : State) -> void:
	pass

func process(delta) -> void:
	pass
