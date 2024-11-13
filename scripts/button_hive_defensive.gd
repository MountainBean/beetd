extends Button

@onready var hive = preload("res://scenes/hives/hive_defensive.tscn")


func _on_button_up():
	Signals.emit_signal("place_mode", hive)
