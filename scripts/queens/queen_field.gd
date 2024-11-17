class_name FieldQueen
extends Queen

static var QUEEN_FIELD_ATTRIBUTES: Array = [
	0.5,					# BEE_SPAWN_RATE
	0.02,					# BEE_PRODUCTIVITY
	temperament.PASSIVE,	# BEE_TEMPERAMENT
	50,						# BEE_HEALTH
	80.0					# BEE_SPEED
]

static var QUEEN_FIELD_ICON: Texture = preload("res://assets/custom/queen.png")
static var HIVE_MODIFIER_ICON: Texture = preload("res://assets/custom/hive_attribute_gathering.png")

const QUEEN_NAME = "Field Queen"
const QUEEN_DESCRIPTION = "Friendly queen. Likes open fields. Generates resources slowly"

func _init(qty: int = 1):
	super._init(QUEEN_NAME, QUEEN_DESCRIPTION, QUEEN_FIELD_ATTRIBUTES, qty)
	icon = QUEEN_FIELD_ICON
