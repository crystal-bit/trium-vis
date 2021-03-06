extends VBoxContainer

# NOTE: most of the code for this script is really similar 
# (copy pasted actually) to the "Player2Cards.gd". 
# It should be generalized.
# The differences are:
#   - Player1Cards.gd (this script) handles player selection
#   - Player2Cards.gd handles the computer AI

var selected_card_index
var CARDS_COUNT = GlobalState.get_cards_count()

onready var battle: Node = get_parent()


func _ready():
	# set an initial selected card
	set_current_selected_card(0)


func get_card_container_at(index):
	""" Get a Card node given an integer index """
	assert index <= get_card_count() - 1
#	var card_container = get_child(index)
	var card_container = _get_cards_list()[index]
	return card_container.get_parent()


func get_card_count():
	""" Get the card count in the player hand """
	return len(_get_cards_list())
#	var count = 0
#	for c in get_children():
#		if "Container" in c.name and c.get_child_count() == 1:
#			count += 1
#	return count


func set_current_selected_card(index):
	assert index <= get_card_count() - 1
	var selected_card = null
	# if there is a selected card
	if selected_card_index != null:
		selected_card = get_child(selected_card_index).get_child(0)
		move_left(selected_card, 50)
	
	var new_selected_card =  get_child(index).get_child(0)
	move_right(new_selected_card, 50)
	selected_card_index = index
	

func move_right(card_container, offset):
	$Tween.interpolate_property(
		card_container, 
		"rect_position", 
		Vector2(0, 0), 
		Vector2(offset, 0),
		0.1,  # time
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	$Tween.start()


func move_left(card_container, offset):
	$Tween.interpolate_property(
		card_container, 
		"rect_position", 
		Vector2(0, 0), 
		Vector2(0, 0),
		0.1,  # time
		Tween.TRANS_EXPO,
		Tween.EASE_OUT
	)
	$Tween.start()


func reset_hand():
	for child in get_children():
		# if there is no card in the card container
		if "Container" in child.name and child.get_child_count() == 0:
			var card = load('res://GameObjects/CardFree/Card.tscn')
			var card_instance = card.instance()
			# needed to avoid a crash: Card scene should be fixed to avoid this hack
			card_instance.card.id = 1
			# TODO update back texture before uncommenting this line
			# card_instance.set_covered(!GlobalState.match_rules.get("Open"))
			child.add_child(card_instance)

func randomize_cards():
	# update the seed
	randomize()
	
	""" Randomize cards in the Player hand """
	# for each child
	for child in get_children():
		# if it is a Container
		if "Container" in child.name:
			# get the Card node
			var card = child.get_child(0)
			card.card_id = randi() % (CARDS_COUNT)  # an integer value between 0 and CARDS_COUNT
			card._ready()


func _get_cards_list():
	""" Get an array with all the cards that the player has in his hand. """
	# TODO: can I use groups to simplify this?
	var cards = []
	for c in get_children():
		if "Container" in c.name and c.get_child_count() == 1:
			cards.append(c.get_child(0))
	return cards


func _on_CardSelected_place_card(card_index, field_position):
	var card_container = get_card_container_at(card_index)
	get_parent().get_node("Field").add_card_at_position(card_container, field_position)
	
	# TODO move this code
	# if get_card_count() > 0:
		# reset the current selected card (resets the position offset)
	#	set_current_selected_card(0)

func _on_SelectingCard_new_card_pointed(card_index):
	set_current_selected_card(card_index)

