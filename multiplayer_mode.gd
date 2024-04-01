extends Control

@export var DEFAULT_SERVER_IP = "127.0.0.1"
@export var PORT = 3131
@export var MAX_CONNECTIONS = 10

var player_info = {
	"name": "KİMSİN???"
}

var peer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Hook up multiplayer signals. These two will emit to every player on the server, and the server itself.
	multiplayer.peer_connected.connect(_on_player_connected)
	multiplayer.peer_disconnected.connect(_on_player_disconnected)
	
	# Hook up multiplayer client signals.
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
	GameMode.players[multiplayer.get_unique_id()] = player_info

func join_game(server_ip = DEFAULT_SERVER_IP):
	peer = ENetMultiplayerPeer.new()
	peer.create_client(server_ip, PORT)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.multiplayer_peer = peer


@rpc("call_local", "reliable")
func start_game(game_scene_path = "res://table.tscn"):
	get_tree().change_scene_to_file(game_scene_path)

@rpc("any_peer", "reliable")
func register_player(new_player_info):
	var new_player_id = multiplayer.get_remote_sender_id()
	GameMode.players[new_player_id] = new_player_info
	for p in GameMode.players:
		print(p)

# Server and all clients
func _on_player_connected(id):
	print("Player connected: ID :", id)
	register_player.rpc_id(id, player_info)

# Server and all clients
func _on_player_disconnected(id):
	print("Player disconnected: ID :", id)

# Only connecting client
func _on_connected_to_server():
	GameMode.players[multiplayer.get_unique_id()] = player_info

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
	start_game.rpc()


func _on_player_name_text_changed(new_text):
	player_info["name"] = new_text
