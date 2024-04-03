extends Node2D

# Card Scene Preloading
const card = preload("res://card.tscn")

var arranged_players : Array

@rpc("any_peer", "call_local", "reliable")
func deal_cards():
	GameMode.played_card_counter = 0

	if multiplayer.is_server():

		GameMode.player_hands.clear()
		GameMode.playdeck = range(1,53)

		var n = GameMode.players.size()
		var player_ids = GameMode.players.keys()
		var random_card_id

		for i in range(52):
			
			random_card_id = GameMode.playdeck.pick_random()
			
			match i%n:
				# Player 0
				0:
					if GameMode.player_hands.has(player_ids[0]):
						GameMode.player_hands[player_ids[0]].append(random_card_id)
					else:
						GameMode.player_hands[player_ids[0]] = [random_card_id]
				
				# Player 1
				1:
					if GameMode.player_hands.has(player_ids[1]):
						GameMode.player_hands[player_ids[1]].append(random_card_id)
					else:
						GameMode.player_hands[player_ids[1]] = [random_card_id]
				
				# Player 2
				2:
					if GameMode.player_hands.has(player_ids[2]):
						GameMode.player_hands[player_ids[2]].append(random_card_id)
					else:
						GameMode.player_hands[player_ids[2]] = [random_card_id]
				
				# Player 3
				3:
					if GameMode.player_hands.has(player_ids[3]):
						GameMode.player_hands[player_ids[3]].append(random_card_id)
					else:
						GameMode.player_hands[player_ids[3]] = [random_card_id]

			GameMode.playdeck.erase(random_card_id)

		for P in player_ids:
			GameMode.player_hands[P].sort()
			process_hand_data.rpc_id(P, GameMode.player_hands[P])

		for Y in GameMode.non_players:
			process_hand_data.rpc_id(Y, GameMode.player_hands)

		GameMode.player_hands.clear()


@rpc("authority", "call_local", "reliable")
func process_hand_data(data):
	if GameMode.client_info["is_player"]:
		GameMode.my_hand = data
		draw_hand(data)
		draw_others()
	else:
		GameMode.player_hands = data

func draw_hand(hand):
	var order_counter = 0
	clear_center()

	for C in $P0.get_children():
		$P0.remove_child(C)
		C.queue_free()

	for C in hand:
		var random_card = card.instantiate()
		var random_card_id = C
		var random_card_key = str("c", random_card_id)
		
		random_card.card_id = random_card_id
		random_card.hovarable = true
		random_card.card_name = GameMode.deck[random_card_key].name
		random_card.card_suit = GameMode.deck[random_card_key].suit
		random_card.card_value = GameMode.deck[random_card_key].value
		random_card.card_sprite = GameMode.deck[random_card_key].sprite

		$P0.add_child(random_card)
		random_card.position = Vector2(48*order_counter,0)
		random_card.z_index = 200 + random_card_id
		order_counter += 1

@rpc("any_peer", "reliable", "call_local")
func clear_center():
	for C in $P0Pos.get_children():
		$P0Pos.remove_child(C)
		C.queue_free()

	for C in $P1Pos.get_children():
		$P1Pos.remove_child(C)
		C.queue_free()

	for C in $P2Pos.get_children():
		$P2Pos.remove_child(C)
		C.queue_free()

	for C in $P3Pos.get_children():
		$P3Pos.remove_child(C)
		C.queue_free()

func take_center():
	for C in $P0Pos.get_children():
		GameMode.cards_taken.append(C.card_id)
	
	for C in $P1Pos.get_children():
		GameMode.cards_taken.append(C.card_id)

	for C in $P2Pos.get_children():
		GameMode.cards_taken.append(C.card_id)

	for C in $P3Pos.get_children():
		GameMode.cards_taken.append(C.card_id)

	GameMode.cards_taken.sort()
	$CardsTaken.clear()
	$CardsTaken.text = ""
	print("iam :: ", multiplayer.get_unique_id()," array : ", GameMode.cards_taken, "text: ", $CardsTaken.text)
	for c in GameMode.cards_taken:
		$CardsTaken.text = str($CardsTaken.text, GameMode.deck[str("c",c)]["name"], "\n")

	clear_center.rpc()

func draw_others():
	for i in range(1,GameMode.player_list.size()):
		var node_to_draw = get_node(str("P", i))

		for C in node_to_draw.get_children():
			node_to_draw.remove_child(C)
			C.queue_free()

		for j in (range(13)):
			var closed_card = card.instantiate()
			var closed_card_key = str("c0")
			
			closed_card.card_name = GameMode.deck[closed_card_key].name
			closed_card.card_suit = GameMode.deck[closed_card_key].suit
			closed_card.card_value = GameMode.deck[closed_card_key].value
			closed_card.card_sprite = GameMode.deck[closed_card_key].sprite

			node_to_draw.add_child(closed_card)
			closed_card.position = Vector2(24*j,0)
			closed_card.z_index = 20*i+j


@rpc("any_peer", "reliable")
func play_card_for_other_players(player, card_to_move):
	
	var node_to_move = get_node(str(GameMode.players[player]["pos"],"Pos"))

	var new_card = card.instantiate()
	var new_card_id = card_to_move
	var new_card_key = str("c", new_card_id)
	
	new_card.card_id = new_card_id
	new_card.hovarable = false
	new_card.card_name = GameMode.deck[new_card_key].name
	new_card.card_suit = GameMode.deck[new_card_key].suit
	new_card.card_value = GameMode.deck[new_card_key].value
	new_card.card_sprite = GameMode.deck[new_card_key].sprite

	node_to_move.add_child(new_card)
	new_card.z_index = 500 + GameMode.played_card_counter
	GameMode.played_card_counter += 1

	var p_node = get_node(GameMode.players[player]["pos"])
	var last_card = p_node.get_child(p_node.get_child_count()-1)
	p_node.remove_child(last_card)
	last_card.queue_free()

# Called when the node enters the scene tree for the first time.
func _ready():

	GameMode.play_card.connect(_on_play_card)

	GameMode.my_Pos = $P0Pos.global_position

	var p0_pos = GameMode.player_list.find(multiplayer.get_unique_id())
	var p1_pos = (p0_pos + 1) % GameMode.player_list.size()
	var p2_pos = (p0_pos + 2) % GameMode.player_list.size()
	var p3_pos = (p0_pos + 3) % GameMode.player_list.size()

	GameMode.players[GameMode.player_list[p0_pos]]["pos"] = "P0"
	GameMode.players[GameMode.player_list[p1_pos]]["pos"] = "P1"
	GameMode.players[GameMode.player_list[p2_pos]]["pos"] = "P2"
	GameMode.players[GameMode.player_list[p3_pos]]["pos"] = "P3"
	
	$P0Name.text = GameMode.players[GameMode.player_list[p0_pos]]["name"]
	$P1Name.text = GameMode.players[GameMode.player_list[p1_pos]]["name"]
	$P2Name.text = GameMode.players[GameMode.player_list[p2_pos]]["name"]
	$P3Name.text = GameMode.players[GameMode.player_list[p3_pos]]["name"]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_deal_button_down():
	deal_cards.rpc()

func _on_play_card(played_card):
	play_card_for_other_players.rpc(multiplayer.get_unique_id(), played_card)

func _on_take_cards_button_down():
	take_center()
