class_name UIItemIcon
extends Control

@export var item: Item:
	set(new_item):
		item = new_item
		item.changed.connect(_update_item_textures)

@onready var item_texture = $ItemTexture
@onready var modifier_texture = $ModifierTexture
@onready var label = $Label

var selected: bool = false

func _ready():
	_update_item_textures()


func _update_item_textures():
	item_texture.texture = item.icon
	modifier_texture.texture = item.modifier_icon
	label.text = str(item.quantity)


func _on_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and not event.pressed:
			get_parent().selected_item = self
