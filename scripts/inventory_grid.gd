extends GridContainer

var inventory: Inventory
var selected_item: UIItemIcon:
	set(item):
		selected_item = item
		if item != null:
			selected_item.modulate = "#777777"
@onready var ui_item = preload("res://scenes/ui_item_icon.tscn")


func _ready():
	inventory = GameManager.get_player_inventory()
	for item in inventory.items:
		_on_item_added(item, item.quantity, item.quantity)
	
	inventory.item_added.connect(_on_item_added)
	inventory.item_removed.connect(_on_item_removed)

func _process(delta):
	if Input.is_action_just_pressed("view_mode"):
		if selected_item != null:
			selected_item.modulate = Color(1,1,1,1)
			selected_item = null

func _on_item_added(item: Item, qty: int, total: int):
	# render the new item in the grid on a ItemIcon
	var new_ui_item = ui_item.instantiate() as UIItemIcon
	new_ui_item.item = item
	add_child(new_ui_item)


func _on_item_removed(item: Item, qty: int, total: int):
	for ui_item in get_children() as Array[UIItemIcon]:
		if ui_item.item == item:
			if total == 0:
				remove_child(ui_item)
			else:
				ui_item._update_item_textures()
