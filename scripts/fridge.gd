extends StaticBody2D

# Get references to both sprites
@onready var closed_sprite: Sprite2D = $ClosedSprite
@onready var open_sprite: Sprite2D = $OpenSprite
@onready var label: Label = $Label


var is_open: bool = false
var player_in_range: bool = false

func _unhandled_input(event):
	if player_in_range and event.is_action_pressed("ui_accept"):
		toggle_fridge()
		
func toggle_fridge():
	is_open = not is_open
	
	if is_open:
		closed_sprite.visible = false # Hide the closed fridge
		open_sprite.visible = true    # Show the open fridge
		label.text = "Press Space to Close" # Change text when open
		print("Fridge opened!")
	else:
		closed_sprite.visible = true  # Show the closed fridge
		open_sprite.visible = false   # Hide the open fridge
		label.text = "Press Space to Open" # Change text when closed
		print("Fridge closed!")

# --- AREA 2D SIGNALS ---
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		label.visible = true # Show the prompt when player gets close!
		print("Player entered interaction range.")

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		label.visible = false # Hide the prompt when player walks away
		print("Player left interaction range.")
