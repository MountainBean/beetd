extends Panel

func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			get_parent().empty_panel_clicked(get_index())
