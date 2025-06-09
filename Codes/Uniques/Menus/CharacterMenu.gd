extends CanvasLayer

@onready var obj_window:Control = get_node("Window")
@onready var obj_viewport:Viewport = get_node("SubViewportContainer/Viewport")

@onready var obj_joypads:HBoxContainer = obj_window.get_node("Joypads")
@onready var obj_selection:HBoxContainer = obj_window.get_node("Players")
var ready_players = []

@onready var obj_ready:Node2D = get_node("Ready")
@onready var obj_ready_keyboards:VBoxContainer = obj_ready.get_node("Keyboards")


func _ready():
	obj_window.reparent(obj_viewport)
	for selection in obj_selection.get_children():
		selection.set_ready.connect(check_readys)

	obj_viewport.get_parent().visible = true
	Input.joy_connection_changed.connect(joypad_changed)
	check_joypads()

func joypad_changed(id:int,connected:bool):
	if not connected:
		for node in obj_selection.get_children():
			node.leave()
	check_joypads()
	


func check_joypads():
	for node in obj_joypads.get_children():
		node.joy_disconnect()
	for joy in range(len(Input.get_connected_joypads())):
		obj_joypads.get_children()[joy].joy_connect()



func _input(event):
	if event is InputEventJoypadButton:
		#print(event.device)
		pass

func check_readys():
	ready_players = []
	var p_in:int = 0
	for selection in obj_selection.get_children():
		p_in += int(selection.visible)
		if selection.is_ready:
			
			ready_players.append(selection)
	if p_in == len(ready_players):
		launch_game()

func launch_game():
	var players_data:Dictionary = {}
	var stats_data:Dictionary = {}
	for id in range(len(ready_players)):
		players_data[id] = {
			"input_map": ready_players[id].input_pack,
			"skin": ready_players[id].skin
		}
		stats_data[id] = {
			"wins": 0,
			"deaths": 0,
			"damage": 0,
			"damage_taken": 0,
		}
	PartyManager.match_data["players"] = players_data
	PartyManager.match_data["stats"] = stats_data
	GameManager.change_scene("game")


func _on_input_box_2_action_just_pressed(action_name):
	if action_name == "pause":
		GameManager.change_scene("menu_main")

func player_joined(player:Control):
	player.visible = true
	if player.controller_id == -1:
		obj_ready_keyboards.get_node(str(player.name)).visible = true
	else:
		check_ready_keys()

func player_lock(player:Control):
	if player.controller_id == -1:
		obj_ready_keyboards.get_node(str(player.name)).visible = false

func player_unlock(player:Control):
	if player.controller_id == -1:
		obj_ready_keyboards.get_node(str(player.name)).visible = true

func player_leave(player:Control):
	print(player.name)
	if player.controller_id == -1:
		obj_ready_keyboards.get_node(str(player.name)).visible = false
	else:
		check_ready_keys(true)

func check_ready_keys(leaving=false):
	var any_joypads:bool = false
	var controllers:int = 0
	for node in obj_selection.get_children():
		if node.visible:
			print(node.controller_id)
			if node.controller_id > -1:
				controllers += 1
	
	if leaving:
		if controllers-1 > 0:
			any_joypads = true
	else:
		if controllers > 0:
			any_joypads = true

	obj_ready.get_node("L2").visible = any_joypads
	obj_ready.get_node("L3").visible = any_joypads
