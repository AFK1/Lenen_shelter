extends Button

@onready var main_node = get_tree().get_root().get_node("Game")

func _pressed():
	main_node.pause = not main_node.pause
	self.get_parent().get_node("Label").visible = main_node.pause
