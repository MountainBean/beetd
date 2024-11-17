class_name UI
extends CanvasLayer

@onready var inventory_panel = $Control/InventoryPanel
@onready var inventory_grid = $Control/InventoryPanel/PanelContainer/MarginContainer/InventoryGrid
@onready var curr_item_icon = $Control/CurrItemIcon

func _ready():
	inventory_grid.selected_item_selected.connect(_on_selected_item_selected)
	inventory_grid.selected_item_cleared.connect(_on_selected_item_cleared)


func _on_inventory_panel_hidden():
	if inventory_grid.selected_item != null:
		GameManager.curr_item = inventory_grid.selected_item.item
		Signals.emit_signal("place_mode")

func _on_selected_item_selected(ui_item: UIItemIcon):
	var big_icon = ui_item.duplicate()
	big_icon.modulate = Color(1,1,1,1)
	big_icon.scale = Vector2(2, 2)
	big_icon.position = Vector2(5, 5)
	curr_item_icon.add_child(big_icon)

func _on_selected_item_cleared():
	curr_item_icon.get_child(0).queue_free()
