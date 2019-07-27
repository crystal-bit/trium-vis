extends Label

signal play_selected

func callback():
	emit_signal("play_selected")
	# SceneManager.goto_scene("res://GameScenes/Game/Game.tscn")