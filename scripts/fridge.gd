extends StaticBody2D

# Get references to both sprites
@onready var closed_sprite: Sprite2D = $ClosedSprite
@onready var open_sprite: Sprite2D = $OpenSprite
@onready var label: Label = $Label
@onready var loot_popup: PanelContainer = $LootPopup

var player_reference = null
var is_open: bool = false
var player_in_range: bool = false

func _ready():
	# Connect the custom signal from our LootPopup node to our handler function
	loot_popup.item_selected.connect(_on_item_selected)

func _unhandled_input(event):
	if player_in_range and event.is_action_pressed("ui_accept"):
		toggle_fridge()
		
func toggle_fridge():
	is_open = not is_open
	
	if is_open:
		closed_sprite.visible = false # Hide the closed fridge
		open_sprite.visible = true    # Show the open fridge
		label.text = "Press Space to Close" # Change text when open
		loot_popup.visible = true # Show the item list box
		print("Fridge opened!")
	else:
		closed_sprite.visible = true  # Show the closed fridge
		open_sprite.visible = false   # Hide the open fridge
		label.text = "Press Space to Open" # Change text when closed
		loot_popup.visible = false # Hide the item list box
		print("Fridge closed!")

# --- ITEM SELECTION SIGNAL HANDLER ---
func _on_item_selected(item_name: String):
	print("Player grabbed: ", item_name)
	
	# Give the item to the player if they are standing nearby
	if player_reference:
		player_reference.receive_item(item_name)
	
	# Automatically close the fridge menu when an item is chosen
	if is_open:
		toggle_fridge()

# --- AREA 2D SIGNALS ---
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		player_in_range = true
		player_reference = body # Store the player reference!
		label.visible = true
		print("Player entered interaction range.")

func _on_area_2d_body_exited(body):
	if body.name == "Player":
		player_in_range = false
		player_reference = null # Clear the reference when they walk away
		label.visible = false
		if is_open:
			toggle_fridge()
		print("Player left interaction range.")
		
