extends GridContainer

var inventory: Inventory
var selected_item: UIItemIcon:
	set(item):
		if selected_item != null:
			selected_item.modulate = Color(1,1,1,1)
			emit_signal("selected_item_cleared")
		selected_item = item
		if item != null:
			emit_signal("selected_item_selected", selected_item)
			selected_item.modulate = "#777777"	
@onready var ui_item = preload("res://scenes/ui_item_icon.tscn")

signal selected_item_selected(item: UIItemIcon)
signal selected_item_cleared()

func _ready():
	inventory = GameManager.get_player_inventory()
	for item in inventory.items:
		if item:
			_on_item_added(item, item.inventory_index, item.quantity, item.quantity)
	
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)
	inventory.item_moved.connect(_on_item_moved)

func _process(delta):
	if Input.is_action_just_pressed("view_mode"):
		if selected_item != null:
			_clear_selected_item()

func _on_item_added(item: Item, index: int, qty: int, total: int):
	# render the new item in the grid on a ItemIcon
	var new_ui_item = ui_item.instantiate() as UIItemIcon
	new_ui_item.item = item
	get_child(index).add_child(new_ui_item)


func _on_item_removed(item: Item, index: int, qty: int, total: int):
	var ui_item_to_remove = get_child(index).get_child(0)
	if total == 0:
		Signals.emit_signal("view_mode")
		if selected_item == ui_item_to_remove:
			_clear_selected_item()
		ui_item_to_remove.queue_free()
	else:
		ui_item_to_remove._update_item_textures()
		selected_item = ui_item_to_remove

func _on_item_moved(item: Item, index: int, new_index: int):
	var existing_ui_item = get_child(index).get_child(0)
	existing_ui_item.reparent(get_child(new_index))
	existing_ui_item.position = Vector2.ZERO
	

func empty_panel_clicked(index: int):
	if selected_item != null:
		inventory.move(selected_item.item, selected_item.item.inventory_index, index)
		_clear_selected_item()

func _clear_selected_item():
	selected_item = null
