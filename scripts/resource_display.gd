extends Label

func _ready():
	Signals.connect("resource_count_updated", _on_resource_update)

func _on_resource_update(new_resource_value: float):
	text = "RESOURCE: " + str(round(new_resource_value))
