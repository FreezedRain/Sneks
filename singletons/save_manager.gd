extends Node

func _ready():
    Events.connect("level_completed", self, "_on_level_completed")