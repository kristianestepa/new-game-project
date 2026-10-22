extends PanelContainer

# Define a custom signal that sends the item's name when clicked
signal item_selected(item_name: String)

func _on_apple_pressed() -> void:
	item_selected.emit("Apple")


func _on_milk_pressed() -> void:
	item_selected.emit("Milk")


func _on_potato_pressed() -> void:
	item_selected.emit("Potato")
