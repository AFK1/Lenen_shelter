extends Node2D

@onready var main_node = get_tree().get_root().get_node("Game")

var speed : int
var F : int
var E : int
var W : int
var room_type_now : int
var room_x : int
var room_y : int
var need_x : int

func _ready():
	speed = randi_range(3, 12)
	F = randi_range(3, 12)
	E = randi_range(3, 12)
	W = randi_range(3, 12)
	need_x = 745
	$Timer.start(3)

func _process(delta):
	self.position.x -= 10 * sign(self.position.x - need_x)
	if abs(self.position.x - need_x) <= speed:
		self.position.x = need_x
	

func new_room(new_room_type_now, new_room_x, new_room_y):
	room_type_now = new_room_type_now
	room_x = new_room_x
	room_y = new_room_y
	need_x = new_room_x + 30
	self.position.y = new_room_y + 85
	self.position.x = new_room_x + 30

func _on_timer_timeout():
	if not main_node.pause:
		if room_type_now == 2:
			main_node.food += 2 * F
		elif room_type_now == 3:
			main_node.water += 2 * W
		elif room_type_now == 4:
			main_node.energy += 2 * E
		if randi() % 2 == 0 and room_type_now >= 2:
			need_x = room_x + randi_range(30, 230)
		$Timer.start(3)
