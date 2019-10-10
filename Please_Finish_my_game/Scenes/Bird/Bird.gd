extends Area2D

signal start_flight
signal death

var FLIGHT_CEILING = 28
var GRAVITY = 8
var FLY_UPWARD_VELOCITY = -225
var MAX_DOWNWARD_VELOCITY = 300
var ROTATION_VELOCITY = 250
var FLYING_ROTATION = -45
var DIVING_ROTATION = 90

var ANIMATION_FLAP_SPEED = 3
var ANIMATION_FLY_SPEED = 2

var DEATH_CAUSES = ["TopPipe", "BottomPipe", "Ground"]

enum State {AUTO_PILOT, PLAYING, CRASHING, CRASHED}

var current_state = State.AUTO_PILOT

var screen_size

var vertical_velocity = 0
var should_rotate = false

var script_rand = preload("res://rand_texture.gd")

var jump_count = 0

func _ready():
	# Get the screen size
	screen_size = get_viewport_rect().size
	# Ensure the player does not have control on creation
	set_player_state(State.AUTO_PILOT)

func _physics_process(delta):
	# Start the phase of player control if flight is triggered during the passive phase
	if current_state == State.AUTO_PILOT and Input.is_action_just_pressed("fly"):
		emit_signal("start_flight")
		set_player_state(State.PLAYING)
	# Apply the actual physics depending on the state
	match current_state:
		State.PLAYING:
			# Apply the impact of gravity
			vertical_velocity = clamp(vertical_velocity + GRAVITY, FLY_UPWARD_VELOCITY, MAX_DOWNWARD_VELOCITY)
			# Check if the player is inputting a flight command
			randomize()
			if Input.is_action_just_pressed("fly"):
				jump_count += 1
				get_node("Particles2D").texture = load((script_rand.new().random_texture("user://Godot_test/player")))
				$bird_anim.play("fly")
				print(jump_count)
				if jump_count < 3 :
					get_node("Sprite").texture = load((script_rand.new().random_texture("user://Godot_test/player")))
					# Play the flap animation and apply flight change
					jump_count = 0
				$FlapSound.stream = load((script_rand.new().random_texture("user://Godot_test/sound_jump")))
				$FlapSound.play()
				vertical_velocity = FLY_UPWARD_VELOCITY
				should_rotate = false
				rotation_degrees = FLYING_ROTATION
				$RotationBeginTimout.start()
			# Actually apply the physics
			position.y += vertical_velocity * delta
			# Keep the bird on the screen
			position.y = clamp(position.y, FLIGHT_CEILING, screen_size.y)
			if should_rotate:
				rotation_degrees = clamp(rotation_degrees + ROTATION_VELOCITY * delta, FLYING_ROTATION, DIVING_ROTATION)
		State.CRASHING:
			# While crashing we're under the maximum gravity effect
			vertical_velocity = MAX_DOWNWARD_VELOCITY
			# Actually apply the physics
			position.y += vertical_velocity * delta
			# Nosedive time
			rotation_degrees = clamp(rotation_degrees + ROTATION_VELOCITY * delta, FLYING_ROTATION, DIVING_ROTATION)
		State.CRASHED:
			# No need to fly further down or do anything else, just be sad at the bottom of the screen
			pass
		State.AUTO_PILOT:
			# Auto pilot state is just passive flying so no physics to apply
			pass

func set_player_state(state):
	match state:
		State.PLAYING:
			# Give the player control of the character
			current_state = State.PLAYING
			# Set other control properties
			should_rotate = true
		State.AUTO_PILOT:
			# Take away the player control
			current_state = State.AUTO_PILOT
			# Reset other control properties
			vertical_velocity = 0
			should_rotate = false
			# Reset the position and rotation of the player
			position.y = screen_size.y / 2
			position.x = screen_size.x / 3
			rotation_degrees = 0
		State.CRASHING:
			# Take away the player control
			current_state = State.CRASHING
		State.CRASHED:
			# Take away the player control
			current_state = State.CRASHED

func _on_RotationBeginTimout_timeout():
	# Time to start the rotation as it as been sufficient time after the flap
	should_rotate = true

func _on_Bird_area_entered(area):
	# Only check for death if we're playing
	if current_state == State.PLAYING and area.get_name() in DEATH_CAUSES:
		emit_signal("death")
		randomize()
		$CrashSound.stream = load((script_rand.new().random_texture("user://Godot_test/sound_die")))
		$CrashSound.play()
	# Once we reach the ground we've crashed
	if area.get_name() == "Ground":
		# Play the crash sound again when we hit the ground
		if current_state == State.CRASHING:
			$CrashSound.play()
		set_player_state(State.CRASHED)
	# Until then we're still crashing
	elif area.get_name() == "TopPipe" or area.get_name() == "BottomPipe":
		set_player_state(State.CRASHING)
