## Load and spawn particles from the specified folder
extends Node

const PATH := 'res://scenes/particles/'

var parent_scene : Node
var particles = {}

func _ready():
	load_particles()
	print('%d particles loaded.' % len(particles))

func spawn(id, position, rotation=0, parent=parent_scene):
	var particle = particles[id].instance()
	particle.position = position
	particle.rotation = rotation
	parent.add_child(particle) 

func load_particles():
	for file_name in Utils.list_files_in_directory(PATH):
		var particle_name = file_name.split('.')[0]
		particles[particle_name] = load(PATH + file_name)


