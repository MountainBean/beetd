class_name DefensiveHive
extends ItemHive

# Array indexed by parent class enum HIVE_ATTRIBUTES
static var DEFENSIVE_HIVE_ATTRIBUTES: Array = [
	150.0,		# DEFENCE_RADIUS
	1.0,		# SPAWN_RATE
	8,			# CAP
	0.0,		# BEE_PRODUCTIVITY
	Hive.temperament.AGGRESSIVE,	# BEE_TEMPERAMENT
	20,			# BUILD_COST
	100,		# BEE_HEALTH
	150.0,		# BEE_SPEED
]

static var DEFENSIVE_MODIFIER_ICON: Texture = preload("res://assets/custom/hive_attribute_aggressive.png")

func _init(qty: int = 1):
	super._init("Defensive Hive", "Hive attacks enemies that approach", DEFENSIVE_HIVE_ATTRIBUTES, qty)
	modifier_icon = DEFENSIVE_MODIFIER_ICON
