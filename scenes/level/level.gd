## Everything related to a single level
class_name Level extends Node2D

onready var fsm = StateMachine.new(self, $States, $States/idle, false)
onready var tween = $Tween

onready var terrain = $Terrain
onready var title = $CanvasLayer/Title
onready var snake_holder = $Snakes
onready var segment_holder = $Segments
onready var goal_holder = $Goals
onready var extra_holder = $Extra
onready var particle_holder = $Particles
onready var decorations = $Decorations

# Data
var level_data: LevelData
var hovered_snake

# Input
var mouse_pos: Vector2
var mouse_grid_pos: Vector2

func _ready():
	ParticleManager.parent_scene = particle_holder

func _process(delta):
	process_input()
	if Input.is_action_just_pressed("complete"):
		fsm.next_state = fsm.states.complete
	fsm.process(delta)

func process_input():
	mouse_pos = get_global_mouse_position()
	mouse_grid_pos = Grid.world_to_grid(mouse_pos)
	# $Sprite.position = Grid.grid_to_world(mouse_grid_pos)
	# mouse_pos = get_viewport().get_mouse_position()

func start():
	fsm.next_state = fsm.states.turn

func load_level(data: LevelData):
	level_data = data
	if data.extra_scene != null:
		$CanvasLayer.add_child(data.extra_scene.instance())
	Grid.load_tiles(data.load_tiles(), Globals.BIOMES[data.biome])

	yield(self, "ready")
	terrain.update_tiles()

	var level_objects = data.load_objects()
	for snake in level_objects.snakes:
		snake.connect("hovered", self, "_on_snake_hovered")
		snake.connect("unhovered", self, "_on_snake_unhovered")
		snake.set_segment_holder(segment_holder)
		snake_holder.add_child(snake)
	
	for segment in level_objects.segments:
		segment_holder.add_child(segment)
	
	for goal in level_objects.goals:
		goal_holder.add_child(goal)

	for extra in level_objects.extra:
		extra_holder.add_child(extra)
	
	decorations.setup()

func update_title(text):
	title.text = text
	tween.interpolate_property(title, "percent_visible", 0, 1, 0.2)
	tween.start()

func _on_snake_hovered(snake):
	hovered_snake = snake

func _on_snake_unhovered(snake):
	if hovered_snake == snake:
		hovered_snake = null
