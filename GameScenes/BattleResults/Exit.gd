extends Label

signal exit_selected

func callback():
	emit_signal("exit_selected")
	# SceneManager.goto_scene("res://GameScenes/Menu/MainMenu/MainMenu.tscn")
