extends Node2D 

@onready var raycast = $RayCast2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:

	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if raycast.is_colliding():
		var thing_being_hit = raycast.get_collider()
		#print(thing_being_hit.name)
		if thing_being_hit != null:
			if thing_being_hit.name == "Enemy" and Input.is_action_just_pressed("player_shoot"):
				thing_being_hit.health -= 10
				print("Arghh")
				print(thing_being_hit.health)
			else:
				pass
	else:
		pass
	pass
