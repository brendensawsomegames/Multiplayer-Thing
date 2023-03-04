extends Node2D

var rng = RandomNumberGenerator.new()


@onready var playerContainer = $Players


func _ready():
	# We only need to spawn players on the server
	if !multiplayer.is_server():
		return
	
	multiplayer.peer_connected.connect(add_player)
	multiplayer.peer_disconnected.connect(delete_player)
	
	
	# Spawn already connected players.
	for id in multiplayer.get_peers():
		add_player(id)
	
	if !DisplayServer.get_name() == "headless":
		add_player(1)


func _exit_tree():
	if !multiplayer.is_server():
		return
	multiplayer.peer_connected.disconnect(add_player)
	multiplayer.peer_disconnected.disconnect(delete_player)


func add_player(id: int):
	var character = preload("res://Nodes/player.tscn").instantiate()
	# Set player id
	print("id = " + str(id))
	character.player = id
	
	character.position = Vector2(rng.randi_range(9, 279), rng.randi_range(9, 152))
	character.name = str(id)
	playerContainer.add_child(character, true)


func delete_player(id: int):
	if !playerContainer.has_node(str(id)):
		return
	playerContainer.get_node(str(id)).queue_free()
