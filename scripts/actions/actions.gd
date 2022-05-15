## Actions taken by the player or environment
class_name Actions extends Object

# Base class for all actions
class Action:
	pass

# Actions that move an actor towards a direction
class MoveAction extends Action:
	var actor: Object
	var direction: Vector2

	func _init(actor, direction):
		self.actor = actor
		self.direction = direction