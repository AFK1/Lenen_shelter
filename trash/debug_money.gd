extends Button

var money_need : int

func _ready():
	money_need = Debug.money_giver
	self.text = str(money_need)
	Debug.money_giver -= 1500

func _on_pressed():
	self.get_parent().get_parent().change_money(money_need)
