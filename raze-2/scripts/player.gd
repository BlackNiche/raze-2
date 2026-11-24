extends CharacterBody2D


@export var SPEED = 600.0
@export var JUMP_VELOCITY = -850.0
@export var DOUBLE_JUMP_VELOCITY = -700.0

@export var is_game_paused = false
@export var is_double_jump_used = false

@export var equipped_mags = 0
@export var equipped_mag = 0
@export var equipped_gun = 1

var gun_start_unlocked = true
var gun_side_unlocked = false
var gun_close_unlocked = false
var gun_auto_unlocked = false
var gun_long_unlocked = false
var gun_heavy_unlocked = false
var gun_bang_unlocked = false

var gun_start_enabled = true
var gun_side_enabled = false
var gun_close_enabled = false
var gun_auto_enabled = false
var gun_long_enabled = false
var gun_heavy_enabled = false
var gun_bang_enabled = false

var gun_start_mags = 9
var gun_side_mags = 0
var gun_close_mags = 0
var gun_auto_mags = 0
var gun_long_mags = 0
var gun_heavy_mags = 0
var gun_bang_mags = 0

var gun_start_mag = 18
var gun_side_mag = 0
var gun_close_mag = 0
var gun_auto_mag = 0
var gun_long_mag = 0
var gun_heavy_mag = 0
var gun_bang_mag = 0

var gun_start_mag_max = 18
var gun_side_mag_max = 20
var gun_close_mag_max = 4
var gun_auto_mag_max = 25
var gun_long_mag_max = 4
var gun_heavy_mag_max = 200
var gun_bang_mag_max = 3

var gun_start_mags_max = 18
var gun_side_mags_max = 5
var gun_close_mags_max = 3
var gun_auto_mags_max = 8
var gun_long_mags_max = 4
var gun_heavy_mags_max = 2
var gun_bang_mags_max = 3

func _pickup():
	pass

func _ready() -> void:
	equipped_mags = gun_start_mags
	equipped_mag = gun_start_mag

func _reload():
	if equipped_mags >= 1:
		equipped_mags = equipped_mags - 1
		if equipped_gun == 1:
			equipped_mag = gun_start_mags_max
		elif equipped_gun == 2:
			equipped_mag = gun_side_mags_max
		elif equipped_gun == 3:
			equipped_mag = gun_close_mags_max
		elif equipped_gun == 4:
			equipped_mag = gun_auto_mags_max
		elif equipped_gun == 5:
			equipped_mag = gun_long_mags_max
		elif equipped_gun == 6:
			equipped_mag = gun_heavy_mags_max
		elif equipped_gun == 7:
			equipped_mag = gun_bang_mags_max
	pass

func _process(delta: float) -> void:
	var cursor_position = get_global_mouse_position()
	
	if not is_game_paused:
		$Gun.look_at(cursor_position)
		if Input.is_action_just_pressed("player_reload"):
			_reload()
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
			
		if Input.is_action_just_pressed("player_gun_one"):
			if gun_start_enabled and gun_start_unlocked:
				equipped_gun = 1
				equipped_mags = gun_start_mags
				equipped_mag = gun_start_mag
		if Input.is_action_just_pressed("player_gun_two"):
			if gun_side_enabled and gun_side_unlocked:
				equipped_gun = 2
				equipped_mags = gun_side_mags
				equipped_mag = gun_side_mag
		if Input.is_action_just_pressed("player_gun_three"):
			if gun_close_enabled and gun_close_unlocked:
				equipped_gun = 3
				equipped_mags = gun_close_mags
				equipped_mag = gun_close_mag
		if Input.is_action_just_pressed("player_gun_four"):
			if gun_auto_enabled and gun_auto_unlocked:
				equipped_gun = 4
				equipped_mags = gun_auto_mags
				equipped_mag = gun_auto_mag
		if Input.is_action_just_pressed("player_gun_five"):
			if gun_long_enabled and gun_long_unlocked:
				equipped_gun = 5
				equipped_mags = gun_long_mags
				equipped_mag = gun_long_mag
		if Input.is_action_just_pressed("player_gun_six"):
			if gun_heavy_enabled and gun_heavy_unlocked:
				equipped_gun = 6
				equipped_mags = gun_heavy_mags
				equipped_mag = gun_heavy_mag
		if Input.is_action_just_pressed("player_gun_seven"):
			if gun_bang_enabled and gun_bang_unlocked:
				equipped_gun = 7
				equipped_mags = gun_bang_mags
				equipped_mag = gun_bang_mag
		#deducting ammo
		if Input.is_action_just_pressed("player_shoot"):
			if equipped_mag >= 1:
				# Remove a Round
				equipped_mag = equipped_mag - 1
				# See if the Round hits anything
				if $Gun/RayCast2D.is_colliding():
					var thing_being_hit = $Gun/RayCast2D.get_collider()
					if thing_being_hit != null:
						if thing_being_hit.name == "Enemy":
							thing_being_hit.health -= 10
							print("Arghh")
							print(thing_being_hit.health)
						else:
							pass
				else:
					pass
				pass
	pass
	
	


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
