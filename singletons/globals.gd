extends Node

onready var SCREEN_SIZE = get_viewport().size

enum Colors {GREEN, RED, YELLOW}
const COLOR_RGB = {Colors.GREEN: Color("#738a3d"), Colors.RED: Color("#b02c20"), Colors.YELLOW: Color("#ba8c3c")}
const COLOR_LETTERS = {
	'r': Colors.RED, 'g': Colors.GREEN, 'y': Colors.YELLOW,
	'R': Colors.RED, 'G': Colors.GREEN, 'Y': Colors.YELLOW
	}
