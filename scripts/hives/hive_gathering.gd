class_name GatheringHive
extends Hive

static var GATHERING_HIVE_ATTRIBUTES: Array = [
	150.0,		# DEFENCE_RADIUS
	1.0,		# SPAWN_RATE
	4,			# CAP
	0.05,		# BEE_PRODUCTIVITY
	Hive.temperament.PASSIVE,	# BEE_TEMPERAMENT
	15,			# BUILD_COST
	50,			# BEE_HEALTH
	50.0,		# BEE_SPEED
]

static var GATHERING_MODIFIER_ICON: Texture = preload("res://assets/custom/hive_attribute_gathering.png")
