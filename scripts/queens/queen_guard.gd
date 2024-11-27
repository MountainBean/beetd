class_name GuardQueen
extends Queen

static var QUEEN_GUARD_ATTRIBUTES: Array = [
	1,						# BEE_SPAWN_RATE
	0.0,					# BEE_PRODUCTIVITY
	temperament.AGGRESSIVE,	# BEE_TEMPERAMENT
	50,						# BEE_HEALTH
	120.0					# BEE_SPEED
]

static var QUEEN_GUARD_ICON: Texture = preload("res://assets/custom/queen_guard.png")
static var HIVE_MODIFIER_ICON: Texture = preload("res://assets/custom/hive_attribute_aggressive.png")

const QUEEN_NAME = "Guardbee Queen"
const QUEEN_DESCRIPTION = "Close cousins of the Fieldbee, these bees are highly aggressive and will attack creatures that get close to their hives."

func _init(qty: int = 1):
	super._init(QUEEN_NAME, QUEEN_DESCRIPTION, QUEEN_GUARD_ATTRIBUTES, qty)
	icon = QUEEN_GUARD_ICON
	hive_modifier_icon = HIVE_MODIFIER_ICON
