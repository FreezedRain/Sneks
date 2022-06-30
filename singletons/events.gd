## Keep track of global events
extends Node

signal game_completed

signal level_completed(level)

signal level_transition(idx)

signal undo_pressed
signal undo_remaining(remaining)