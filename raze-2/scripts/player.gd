extends CharacterBody2D


@export var SPEED = 600.0
@export var JUMP_VELOCITY = -850.0
@export var DOUBLE_JUMP_VELOCITY = -700.0

@export var is_game_paused = false
@export var is_double_jump_used = false

var gun_starter_unlocked = true
var gun_sideArm_unlocked = false
var gun_closeRange_unlocked = false
var gun_automatic_unlocked = false
var gun_longRange_unlocked = false
var gun_heavy_unlocked = false
var gun_explosive_unlocked = false

func _process(delta: float) -> void:
	var cursor_position = get_global_mouse_position()
	
	if not is_game_paused:
		$Gun.look_at(cursor_position)
	pass
	
	# If the cursor is to the left of the avatar, make the sprite face left
	var cursor_is_on_left_screen_side = true \
		if get_local_mouse_position().x < $CollisionShape2D.position.x \
		else false
	if cursor_is_on_left_screen_side:
		$Sprite2D.scale.x = -1
		$Gun.scale.y = -1
	else:
		$Sprite2D.scale.x = 1
		$Gun.scale.y = 1


func _physics_process(delta: float) -> void:
	#velocity.y += get_gravity().y * delta
	
	var target_rotation = 0
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		# Align CharacterBody with Surface Normal
		target_rotation = get_floor_normal().angle() + PI/2
	
	# Align CharacterBody with Appropriate Normal
	rotation = lerp_angle(rotation, target_rotation, 50 * delta)
	
	# Reset Double Jump
	if is_double_jump_used and is_on_floor():
		is_double_jump_used = false
	
	# Handle jump.
	if not is_game_paused:
		if Input.is_action_just_pressed("player_jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		if Input.is_action_just_pressed("player_jump") and !is_on_floor() \
		and !is_double_jump_used:
			is_double_jump_used = true
			velocity.y = DOUBLE_JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("player_move_left", "player_move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
