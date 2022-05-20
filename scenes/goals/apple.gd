class_name Apple extends Goal

func _on_set_active():
	if active:
		hide()
	else:
		show()