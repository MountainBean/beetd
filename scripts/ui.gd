class_name UI
extends Control

@onready var inventory_panel = $InventoryPanel
@onready var inventory_grid = $InventoryPanel/InventoryGrid


func _on_inventory_panel_hidden():
	if inventory_grid.selected_item != null:
		GameManager.curr_item = inventory_grid.selected_item.item
		Signals.emit_signal("place_mode")
