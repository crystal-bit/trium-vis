extends Control


enum {
	WIN,  # 0
	LOSE,  # 1
	DRAW  # 2
}


signal battle_ended


var rules = {} setget set_rules  # Game node updates this variable


func set_rules(value):
	""" Initializes the rules. Should be called once before the battle starts """
	rules = value
	
	if rules.get("Open") == false:
		# Update AI cards texture to show the back side of the card
		for card_container in $Player2Cards.get_children():
			if card_container is Control:
				var card = card_container.get_child(0)
				card.covered = true
	
	if rules.get("Random") == true:
		$Player1Cards.randomize_cards()
		# $Player2Cards.randomize_cards()


func _on_Field_match_ended(rules_used):
	var match_result = _get_match_result()
	# update global values
	if match_result == WIN:
		GlobalState.matches_stats["won"] += 1
	elif match_result == LOSE:
		GlobalState.matches_stats["lost"] += 1
	elif match_result == DRAW:
		GlobalState.matches_stats["drawn"] += 1
	emit_signal("battle_ended", match_result)


func _get_match_result() -> int:
	if $Scores/Player1Score.value > $Scores/Player2Score.value:
		return WIN
	if $Scores/Player1Score.value < $Scores/Player2Score.value:
		return LOSE
	else:
		return DRAW
		

func init():
	$Player1Cards.reset_hand()
	$Player1Cards.randomize_cards()
	$Player2Cards.reset_hand()
	#$Player2Cards.randomize_cards()
	
	$GameLogic/SelectionPointer._change_state($GameLogic/SelectionPointer/State/SelectingCard, 0)
	
	$Field.reset_board()
	
	# TODO: add code to decide who is going to play first
	