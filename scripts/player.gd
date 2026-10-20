extends CharacterBody2D

# Exposes the speed variable to the Godot Inspector panel
@export var speed: float = 100.0

# Since CharacterBody2D is now the root, AnimatedSprite2D is a direct child!
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func _physics_process(delta):
	
	# Create a blank 2D vector (0, 0) to track movement direction
	var input_direction = Vector2.ZERO
	
	# Check inputs and adjust the vector components
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
		
	# Normalize the vector so moving diagonally doesn't make you faster
	input_direction = input_direction.normalized()
	
	# --- COLLISION UPGRADE ---
	# Instead of changing 'position' directly, CharacterBody2D uses 'velocity'
	velocity = input_direction * speed
	
	# move_and_slide() moves the character and automatically stops them when hitting walls
	move_and_slide()
	
	# Check if the player is moving or standing still to switch animations
	if input_direction != Vector2.ZERO:
		# If moving horizontally
		if input_direction.x != 0:
			animated_sprite.play("walk_left")
			if input_direction.x < 0:
				animated_sprite.flip_h = false # Face left
			else:
				animated_sprite.flip_h = true # Face right
		# If moving vertically
		elif input_direction.y > 0:
			animated_sprite.play("walk_down")
		elif input_direction.y < 0:
			animated_sprite.play("walk_up")
	else:
		# If standing still
		animated_sprite.play("idle")
