extends CharacterBody2D

@export var health = 100
@export var game_controller: Control
const SPEED = 300.0
const JUMP_VELOCITY = -400.0


func _process(delta: float) -> void:
	if health <= 0:
		game_controller.update_enemy_count()
		queue_free()
	pass
