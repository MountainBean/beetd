class_name Inventory

extends Resource

const MAX_INV_SIZE := 32

@export var items: Array[Item] = []

signal item_added(item: Item, index: int, qty: int, total: int)
signal item_removed(item: Item, index: int, qty: int, total: int)
signal item_moved(item: Item, index: int, new_index: int)

func _init():
	items.resize(MAX_INV_SIZE)

func find(item: Item) -> Item:
	var i = items.find(item)
	if i >= 0:
		return(items[i])
	else:
		return null
	

func add(item: Item, index: int, qty: int = 1):
	assert(index < MAX_INV_SIZE and index >= 0)
	# TODO: handle negative quantities
	var i = items[index]
	
	if not i:
		items[index] = item
		item.inventory = self
		item.inventory_index = index
		i = item
		i.quantity = qty
	else:
		i.quantity += qty
	emit_signal("item_added", item, index, qty, item.quantity)

func remove(item: Item, index: int, qty: int = 1):
	assert(index < MAX_INV_SIZE and index >= 0)
	# TODO: handle negative quantities
	var i = items[index]
	
	if not i:
		return
	else:
		i.quantity -= qty
		if i.quantity < 1:
			items[index] = null
			emit_signal("item_removed", item, index, qty, 0)
		else:
			emit_signal("item_removed", item, index, qty, i.quantity)

func move(item: Item, index: int, new_index: int):
	assert(index < MAX_INV_SIZE and index >= 0)
	assert(new_index < MAX_INV_SIZE and new_index >= 0)
	items[new_index] = items[index]
	items[index] = null
	item.inventory_index = new_index
	emit_signal("item_moved", item, index, new_index)
