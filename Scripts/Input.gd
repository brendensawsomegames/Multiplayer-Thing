extends MultiplayerSynchronizer

@export var direction: Vector2 = Vector2.ZERO



func _ready():
	set_process(get_multiplayer_authority() == multiplayer.get_unique_id())
	if !multiplayer.is_server() || true:
		print("get_multiplayer_authority() = " + str(get_multiplayer_authority()))
		print("multiplayer.get_unique_id() = " + str(multiplayer.get_unique_id()))
		print("good = " + str(get_multiplayer_authority() == multiplayer.get_unique_id()))


func _process(_delta):
	direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if !multiplayer.is_server():
		print(direction)
