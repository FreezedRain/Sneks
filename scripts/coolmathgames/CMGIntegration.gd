extends Node

const IS_CMG_BUILD = true
var IS_DEBUG = OS.is_debug_build()
var completed_all: bool = false

var valid_domains = [
	"www.coolmathgames.com",
	"edit.coolmathgames.com",
	"www.stage.coolmathgames.com",
	"edit-stage.coolmathgames.com",
	"dev.coolmathgames.com",
	"m.coolmathgames.com",
	"www.coolmath-games.com",
	"edit.coolmath-games.com",
	"edit-stage.coolmath-games.com",
	"dev.coolmath-games.com",
	"m.coolmath-games.com"
]

# func _ready():
# 	JavaScript.eval("$(window).bind(\n'touchmove',\nfunction(e) {\ne.preventDefault();\n}\n);")

func setup_level_unlock():
	if !IS_CMG_BUILD:
		return
	JavaScript.eval("""
	var unlocked = false
	function unlockAllLevels()
	{
	unlocked = true
	}
	""", true)

func process_level_unlock():
	if !IS_CMG_BUILD or completed_all:
		return
	if JavaScript.eval("unlocked"):
		SaveManager.complete_all_levels()

func is_valid():
	if !IS_CMG_BUILD:
		return true
	if IS_DEBUG:
		return true
	if not OS.get_name()=="HTML5":
		return true
	return valid_domains.has(get_domain())
	
func get_domain():
	if !IS_CMG_BUILD:
		return ""
	return str(JavaScript.eval("document.location.host"))

func game_start():
	if !IS_CMG_BUILD:
		return
	if IS_DEBUG:
		print("GAME START")
	JavaScript.eval('parent.cmgGameEvent("start");', true)
	
func level_start(level_num):
	if !IS_CMG_BUILD:
		return
	if IS_DEBUG:
		print("LEVEL START: %s" % level_num)
	JavaScript.eval('parent.cmgGameEvent("start","' + str(level_num) + '");', true)

func level_restart(level_num):
	if !IS_CMG_BUILD:
		return
	if IS_DEBUG:
		print("LEVEL RESTART: %s" % level_num)
	JavaScript.eval('parent.cmgGameEvent("replay","' + str(level_num) + '");', true)

