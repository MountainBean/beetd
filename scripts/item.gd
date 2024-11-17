class_name Item
extends Resource

var name: String
var description: String
var icon: Texture
var stackable: bool
var quantity: int
var modifier_icon: Texture

var buildable: bool = false

var inventory: Inventory
var inventory_index: int

func _init(item_name: String, item_desc: String, qty: int = 1):
	name = item_name
	description = item_desc
	quantity = qty
