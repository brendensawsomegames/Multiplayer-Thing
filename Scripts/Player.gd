extends Node2D


const speed = 1
const friction = 0.1

@onready var input = $Input
@onready var sprite = $Sprite
@onready var collision_detection = $CollisionDetection


# Set by the authority, synchronized on spaw`n.
@export var player := 1 :
	set(id):
		player = id
		# Give authority over the player input to the appropriate peer.
		$Input.set_multiplayer_authority(id)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _process(_delta):
	var velocity: Vector2 = Vector2.ZERO
	
	velocity += input.direction * speed
#	velocity = Vector2.RIGHT * 0.5
#	velocity -= velocity * friction
	
	collision_detection.rotation = velocity.angle()
	position += velocity.normalized()
	
#	snap_sprite()





func _snap_sprite():
	sprite.position = Vector2.ZERO
