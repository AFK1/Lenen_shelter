extends Node2D

var food = 500
var max_food = 1250
var water = 500
var max_water = 1250
var energy = 500
var max_energy = 1250

var money = 2000

var pause : bool = false
var regen : bool = true

var build_mode : bool = false

var x_of_build_button : int # idk how to connect 2 and more args
var y_of_build_button : int 
var type_of_build_button : int # sry, i hate some godot forms

var selected_human : Node2D

var human_count : int = 3
var room_count : int = 1

var room_array : Array = [
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,1,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0]
	]

var rooms_sizes : Array = [0, 1, 4, 4, 4]
var rooms_costs : Array = [0, 250, 500, 500, 500]
var rooms_icons : Array = [
	preload("res://assets/free_brick.jpg"),
	preload("res://assets/free_brick.jpg"),
	preload("res://assets/food_ic.png"),
	preload("res://assets/water_ic.png"),
	preload("res://assets/energy_ic.png")
]
var rooms_scenes : Array = [
	preload("res://trash/room.tscn"),
	preload("res://trash/lift.tscn"),
	preload("res://trash/room.tscn"),
	preload("res://trash/room.tscn"),
	preload("res://trash/room.tscn"),
]

var human_scene = preload("res://trash/human.tscn")

func _ready():
	$Interface/Control/Money/Label.text = str(money)
	$Humans_timer.start(10)
	$Money_timer.start(1)
	selected_human = null

func _input(event):
	if event is InputEventKey:
		build_mode = false
		$Trash.delete_children()
		if event.pressed:
			if event.is_action_pressed("pause"):
				pause = not pause
				$Interface/Control/Label.visible = pause
			elif event.is_action_pressed("build_inter"):
				$Interface/Control/Build_inter.visible = not $Interface/Control/Build_inter.visible
	elif event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				var mousePos = get_viewport().get_mouse_position()
				if selected_human == null:
					for human in $Humans.get_children():
						if human.get_node("image").get_rect().has_point(human.get_node("image").to_local(mousePos)):
							selected_human = human
							$Interface/Control/Stater.visible = true
							$Interface/Control/Stater/VBoxContainer2/Food/ProgressBar.value = human.F * 100 / 12
							$Interface/Control/Stater/VBoxContainer2/Water/ProgressBar.value = human.W * 100 / 12
							$Interface/Control/Stater/VBoxContainer2/Energy/ProgressBar.value = human.E * 100 / 12
							return
				else:
					for room in $Rooms.get_children():
						if room.get_node("Texture").get_rect().has_point(room.get_node("Texture").to_local(mousePos)):
							selected_human.new_room(room.type, room.position.x, room.position.y)
							$Interface/Control/Stater.visible = false
							selected_human = null
							return
					selected_human = null
					$Interface/Control/Stater.visible = false
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if $Camera2D.position.y < 900:
				$Camera2D.position.y += 20
		elif event.button_index == MOUSE_BUTTON_WHEEL_UP:
			if $Camera2D.position.y > 500:
				$Camera2D.position.y -= 20

func _process(delta):
	if selected_human == null:
		$Polygon2D.set_position(Vector2(-400, 0))
	else:
		$Polygon2D.set_position(Vector2(selected_human.position.x - 18, selected_human.position.y - 58))
	if not pause:
		food -= delta * human_count
		water -= delta * human_count
		energy -= delta * room_count
		if food < 0:
			food = 0
			regen = true
		if water < 0:
			water = 0
			regen = true
		if energy < 0:
			food = 0
			energy = true
		$Interface/Control/VBoxContainer/Energy/ProgressBar.value = energy * 100 / max_energy
		$Interface/Control/VBoxContainer/Food/ProgressBar.value = food * 100 / max_food
		$Interface/Control/VBoxContainer/Water/ProgressBar.value = water * 100 / max_water

func printer():
	print("A")

func set_room(x, y, room_type):
	for i in range(rooms_sizes[room_type]):
		room_array[y+i][x] = room_type
	var scene_res = rooms_scenes[room_type].instantiate()
	scene_res.type = room_type
	if room_type >= 2:
		scene_res.get_node("Type_texture").set_texture(rooms_icons[room_type])
	scene_res.set_position(Vector2(y * 66 + 114, x * 99 + 313))
	$Rooms.add_child(scene_res)
	room_count += 1
	change_money(-rooms_costs[room_type])
	build_mode = false
	$Trash.delete_children()

func build_room(room_type):
	build_mode = true
	$Trash.delete_children()
	for i in range(1, 19):
		for j in range(1, 9):
			if room_array[i][j] != 0:
				continue
			if (room_array[i][j-1] != 1 or room_type != 1) and (room_array[i+1][j] == 0 and room_array[i-1][j] == 0):
				continue
			var button = Button.new()
			if room_array[i+1][j] == 0:
				button.set_position(Vector2(i * 66 + 114, j * 99 + 313))
				button.pressed.connect(func(): set_room(j, i, room_type))
			else:
				button.set_position(Vector2(i * 66 + 114 - 66 * (rooms_sizes[room_type]-1), j * 99 + 313))
				button.pressed.connect(func(): set_room(j, i-rooms_sizes[room_type]+1, room_type))
			button.set_size(Vector2(66 * rooms_sizes[room_type], 99))
			$Trash.add_child(button)

func change_money(new_money):
	money += new_money
	$Interface/Control/Money/Label.text = str(money)
	get_tree().call_group("btn_disable_need", "update_btn")


func _on_human_timer_timeout():
	if not pause:
		if randi() % 4 == 0:
			var new_human = human_scene.instantiate()
			new_human.set_position(Vector2(1500, 400))
			$Humans.add_child(new_human)
			human_count += 1
		$Humans_timer.start(10)


func _on_money_timer_timeout():
	if not pause:
		change_money((room_count + human_count))
		$Money_timer.start(1)
