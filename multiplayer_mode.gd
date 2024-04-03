extends Control

@export var DEFAULT_SERVER_IP = "127.0.0.1"
@export var PORT = 3131
@export var MAX_CONNECTIONS = 10
@export var MAX_ALLOWED_SEATS = 4

var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hook up multiplayer signals. These two will emit to every player on the server, and the server itself.
	multiplayer.peer_connected.connect(_on_client_connected)
	multiplayer.peer_disconnected.connect(_on_client_disconnected)
	
	# Hook up multiplayer client signals. Only on clients.
	multiplayer.connected_to_server.connect(_on_connected_to_server)
	multiplayer.connection_failed.connect(_on_connection_failed)
	multiplayer.server_disconnected.connect(_on_server_disconnected)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func host_game():
	peer = ENetMultiplayerPeer.new()
	var error = peer.create_server(PORT, MAX_CONNECTIONS)
	if error:
		return error
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer
	register_client.rpc_id(multiplayer.get_unique_id(), GameMode.client_info)

func join_game(server_ip = DEFAULT_SERVER_IP):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(server_ip, PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer

@rpc("authority", "call_local", "reliable")
func start_game(game_scene_path = "res://table.tscn"):
	get_tree().change_scene_to_file(game_scene_path)

@rpc("authority", "call_local", "reliable")
func process_player_data(player_list_data:Array):
	GameMode.player_list = player_list_data

@rpc("call_local", "any_peer", "reliable")
func register_client(info):
	var sender_id = multiplayer.get_remote_sender_id()
	GameMode.clients[sender_id] = info
	if info["is_player"]:
		GameMode.players[sender_id] = info
	else:
		GameMode.non_players[sender_id] = info
	update_labels()

@rpc("any_peer", "call_local", "reliable")
func sit():
	var client_id = multiplayer.get_remote_sender_id()
	if GameMode.players.size() < MAX_ALLOWED_SEATS:
		GameMode.clients[client_id]["is_player"] = true
		GameMode.players[client_id] = GameMode.clients[client_id]
		GameMode.non_players.erase(client_id)

		update_labels()


@rpc("any_peer", "call_local", "reliable")
func stand():
	var client_id = multiplayer.get_remote_sender_id()
	GameMode.clients[client_id]["is_player"] = false
	GameMode.non_players[client_id] = GameMode.clients[client_id]
	GameMode.players.erase(client_id)

	update_labels()

func update_labels():
	$Players.clear()
	for P in GameMode.players:
		$Players.add_text(GameMode.players[P]["name"])
		$Players.add_text("\n")

	$NonPlayers.clear()
	for P in GameMode.non_players:
		$NonPlayers.add_text(GameMode.non_players[P]["name"])
		$NonPlayers.add_text("\n")


# Server and all clients
# All member clients including server send the new client their info
func _on_client_connected(id):
	register_client.rpc_id(id, GameMode.client_info)

# Server and all clients
func _on_client_disconnected(id):
	print("Client disconnected: ID :", id)

# Only connecting client
# New client sends info to everyone, including self and server
func _on_connected_to_server():
	register_client.rpc_id(multiplayer.get_unique_id(), GameMode.client_info)


# Only connecting client
func _on_connection_failed():
	print("Connection to server failed.")

# Only connecting client
func _on_server_disconnected():
	print("Server disconnected.")

func _on_host_button_down():
	host_game()
	$Host.disabled = true
	$Join.disabled = true
	$Start.disabled = false
	$IPAdress.editable = false
	$PlayerName.editable = false


func _on_join_button_down():
	join_game($IPAdress.text)
	$Host.disabled = true
	$Join.disabled = true
	$IPAdress.editable = false
	$PlayerName.editable = false


func _on_start_button_down():
	process_player_data.rpc(GameMode.players.keys())
	start_game.rpc()


func _on_player_name_text_changed(new_text):
	GameMode.client_info["name"] = new_text


func _on_seat_toggled(toggled_on):
	if(toggled_on):
		sit.rpc()
		$Seat.text = "Oyundan Kalk"
	else:
		stand.rpc()
		$Seat.text = "Oyuna Otur"