extends Node

const port = 4433


func _ready():
	# Start paused
#	get_tree().paused = true
	# You can save bandwidth by disabling server relay and peer notifications
	multiplayer.server_relay = false
	
	# If is headless then start server in headless mode.
	if DisplayServer.get_name() == "headless":
		print("Starting dedicated server")
		host_server.call_deferred()

func _on_host_pressed():
	host_server.call_deferred()


func host_server():
	# Start as server
	print("Creating server")
	var peer = ENetMultiplayerPeer.new()
	peer.create_server(port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to create server")
		return
	multiplayer.multiplayer_peer = peer
	print("Server created")
	
	start_game()


func _on_connect_pressed():
	# Start as client
	print("Connecting to server")
	var txt : String = $UI/Net/Options/Remote.text
	if txt == "":
		OS.alert("Need a remote to connect to")
		return
	var peer = ENetMultiplayerPeer.new()
	peer.create_client(txt, port)
	if peer.get_connection_status() == MultiplayerPeer.CONNECTION_DISCONNECTED:
		OS.alert("Failed to connect to server")
		return
	multiplayer.multiplayer_peer = peer
	print("Connected to server")
	
	
	start_game()


func start_game():
	print("Starting game")
	
	$UI.hide()
	get_tree().paused = false
	
	if multiplayer.is_server():
		change_level.call_deferred(load("res://Scenes/world.tscn"))


# Call this function deferred and only on the server
func change_level(scene : PackedScene):
	var level = $Level
	# Remove old level
	for c in level.get_children():
		level.remove_child(c)
		c.queue_free()
	# Insert new level
	level.add_child(scene.instantiate())


# The server can restart the level by pressing Home.
func _input(event):
	if not multiplayer.is_server():
		return
	if event.is_action("ui_home") and Input.is_action_just_pressed("ui_home"):
		change_level.call_deferred(load("res://level.tscn"))
