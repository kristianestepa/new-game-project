extends CharacterBody2D

@export var speed: float = 100.0
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

# Tracks what the player is currently holding
var held_item: String = ""

# Keep track of which way the player is facing (defaults to "down")
var facing_direction: String = "down"

func _physics_process(_delta):
	
	var input_direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		input_direction.x += 1
	if Input.is_action_pressed("ui_left"):
		input_direction.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_direction.y += 1
	if Input.is_action_pressed("ui_up"):
		input_direction.y -= 1
		
	input_direction = input_direction.normalized()
	
	velocity = input_direction * speed
	move_and_slide()
	
	# --- ANIMATION & DIRECTION TRACKING ---
	if input_direction != Vector2.ZERO:
		# If moving horizontally
		if input_direction.x != 0:
			animated_sprite.play("walk_left")
			if input_direction.x < 0:
				facing_direction = "left"  # Remember we are facing left
				animated_sprite.flip_h = false 
			else:
				facing_direction = "right" # Remember we are facing right
				animated_sprite.flip_h = true 
				
		# If moving vertically down
		elif input_direction.y > 0:
			facing_direction = "down"      # Remember we are facing down
			animated_sprite.play("walk_down")
			animated_sprite.flip_h = false
			
		# If moving vertically up
		elif input_direction.y < 0:
			facing_direction = "up"        # Remember we are facing up
			animated_sprite.play("walk_up")
			animated_sprite.flip_h = false
			
	else:
		# When standing still, play the idle animation that matches our last facing direction!
		# (Assumes your idle animations are named: idle_down, idle_left, idle_up, etc.)
		
		# Note: If you use walk_left flipped for right, you can map "right" to use "idle_left" with flip_h = true, 
		# or make an explicit "idle_right" animation. Here is a safe way using your named animations:
		if facing_direction == "right":
			animated_sprite.play("idle_left")
			animated_sprite.flip_h = true
		else:
			animated_sprite.play("idle_" + facing_direction)
			animated_sprite.flip_h = false

# Function to give an item to the player
func receive_item(item_name: String):
	held_item = item_name
	print("Player is now holding: ", held_item)
	
	# Find the HUD label in the main scene and update its text
	var hud_label = get_node_or_null("/root/Game/HUDLabel")
	if hud_label:
		hud_label.text = "Holding: " + held_item
