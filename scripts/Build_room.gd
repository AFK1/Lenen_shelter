extends Control

@onready var main_node = get_tree().get_root().get_node("Game")
var room_type_to_build : int

func _ready():
	GameManager.room_build_buttons += 1
	room_type_to_build = GameManager.room_build_buttons

func _on_button_pressed():
	self.get_parent().get_parent().get_parent().visible = false
	main_node.build_room(room_type_to_build)

func update_btn():
	if main_node.money >= 500:
		$Button.disabled = false
	else:
		$Button.disabled = true
