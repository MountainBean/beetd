extends Item
class_name Queen

enum temperament {
	PASSIVE,
	AGGRESSIVE
}

enum BEE_ATTRIBUTES {
	BEE_SPAWN_RATE,
	BEE_PRODUCTIVITY,
	BEE_TEMPERAMENT,
	BEE_HEALTH,
	BEE_SPEED
}

var bee_spawn_rate: float
var bee_productivity: float
var bee_temperament: temperament
var bee_health: int
var bee_speed: float

func _init(item_name: String, item_desc: String, queen_attributes: Array, qty: int = 1):
	super._init(item_name, item_desc, qty)
	bee_spawn_rate = queen_attributes[BEE_ATTRIBUTES.BEE_SPAWN_RATE]
	bee_productivity = queen_attributes[BEE_ATTRIBUTES.BEE_PRODUCTIVITY]
	bee_temperament = queen_attributes[BEE_ATTRIBUTES.BEE_TEMPERAMENT]
	bee_health = queen_attributes[BEE_ATTRIBUTES.BEE_HEALTH]
	bee_speed = queen_attributes[BEE_ATTRIBUTES.BEE_SPEED]
