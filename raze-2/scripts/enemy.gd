extends CharacterBody2D


@export var SPEED = 600.0
@export var JUMP_VELOCITY = -850.0
@export var DOUBLE_JUMP_VELOCITY = -600.0

@onready var vision_area: Area2D = $VisionArea
@onready var line_of_sight: RayCast2D = $LineOfSight

@export var health = 100
@export var game_controller: Control

var current_target = null
var is_double_jump_used = false
var time_elapsed : float = 0.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if health <= 0:
		game_controller.update_enemy_count()
		queue_free()
	time_elapsed += delta
	print(time_elapsed)
	if time_elapsed >= 5.0:
		velocity.y = JUMP_VELOCITY
		time_elapsed = 0.0
	pass


func _physics_process(delta: float) -> void:
	# Gravity
	var target_rotation = 0
	print("Is on floor", is_on_floor())
	if not is_on_floor():
		velocity += get_gravity() * delta
		print("Velocity: ", velocity)
		print("Gravity: ", get_gravity())
	else:
		# Align CharacterBody with Surface Normal
		target_rotation = get_floor_normal().angle() + PI/2
	
	# Align CharacterBody with Appropriate Normal
	rotation = lerp_angle(rotation, target_rotation, 10 * delta)
	
	# Reset Double Jump
	if is_double_jump_used and is_on_floor():
		is_double_jump_used = false
	
	move_and_slide()

func _on_vision_area_body_entered(body: Node2D) -> void:
	if current_target == null:
		print("Body:", body.name)
		pass
	pass # Replace with function body.


func _on_vision_area_body_exited(body: Node2D) -> void:
	pass # Replace with function body.
