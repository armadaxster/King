extends Node2D

# Card Scene Preloading
const card = preload("res://card.tscn")

@rpc("any_peer", "call_local", "reliable")
func deal_cards():

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
	else:
		GameMode.player_hands = data

func draw_hand(hand):
	var order_counter = 0

	for C in $P0.get_children():
		$P0.remove_child(C)
		C.queue_free()

	for C in hand:
		var random_card = card.instantiate()
		var random_card_id = C
		var random_card_key = str("c", random_card_id)
		
		random_card.card_id = random_card_id
		random_card.card_name = GameMode.deck[random_card_key].name
		random_card.card_suit = GameMode.deck[random_card_key].suit
		random_card.card_value = GameMode.deck[random_card_key].value
		random_card.card_sprite = GameMode.deck[random_card_key].sprite

		$P0.add_child(random_card)
		random_card.position = Vector2(50*order_counter,0)
		random_card.z_index = 100 + random_card_id
		order_counter += 1


# Called when the node enters the scene tree for the first time.
func _ready():

	var p0_pos = GameMode.player_list.find(multiplayer.get_unique_id())
	var p1_pos = (p0_pos + 1) % GameMode.player_list.size()
	var p2_pos = (p0_pos + 2) % GameMode.player_list.size()
	var p3_pos = (p0_pos + 3) % GameMode.player_list.size()
	
	$P0Name.text = GameMode.players[GameMode.player_list[p0_pos]]["name"]
	$P1Name.text = GameMode.players[GameMode.player_list[p1_pos]]["name"]
	$P2Name.text = GameMode.players[GameMode.player_list[p2_pos]]["name"]
	$P3Name.text = GameMode.players[GameMode.player_list[p3_pos]]["name"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	deal_cards.rpc()
