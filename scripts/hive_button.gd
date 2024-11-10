extends Button

@onready var hive = preload("res://scenes/hive.tscn")


func _on_button_up():
	Signals.emit_signal("place_mode", hive)
