class_name Inventory

extends Resource

@export var items: Array[Item] = []

signal item_added(item: Item, qty: int, total: int)
signal item_removed(item: Item, qty: int, total: int)

func find(item: Item) -> Item:
	var i = items.find(item)
	if i >= 0:
		return(items[i])
	else:
		return null
	

func add(item: Item, qty: int = 1):
	# TODO: handle negative quantities
	var i = find(item)
	
	if not i:
		items.append(item)
		item.inventory = self
		i = item
		i.quantity = qty
	else:
		i.quantity += qty
	emit_signal("item_added", item, qty, item.quantity)

func remove(item: Item, qty: int = 1):
	# TODO: handle negative quantities
	var i = find(item)
	
	if not i:
		return
	else:
		i.quantity -= qty
		if i.quantity < 1:
			items.erase(i)
			emit_signal("item_removed", item, qty, 0)
		else:
			emit_signal("item_removed", item, qty, i.quantity)
