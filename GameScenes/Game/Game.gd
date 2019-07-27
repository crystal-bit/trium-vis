extends Control

# called manually (eg: from SceneManager.goto_scene) to init parameters
func init(params):
	# set_rules
	$Battle.rules = params

func _on_Results_play_again():
	$Battle.init()
	$Fade/AnimationPlayer.play("fade_from_black")
