extends Control

func _ready():
	visible = false



func _on_button_pressed():
	visible = false


func _on_build_menu_pressed():
	visible = not visible
