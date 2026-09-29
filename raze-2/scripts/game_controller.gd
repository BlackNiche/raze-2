extends Control

@export var player = Node2D

var enemy_count = 1

var has_won = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func update_enemy_count():
	enemy_count -= 1
	evaluate_win_condition()

func evaluate_win_condition():
	if enemy_count == 0:
		has_won = true
		display_win_screen()
	pass

func display_win_screen():
	player.is_game_paused = true
	$"Win-Screen".visible = true
	pass

func display_loss_screen():
	pass


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Game.tscn")
	pass # Replace with function body.
