extends CanvasLayer

@onready var obj_window:Control = get_node("Window")
@onready var obj_viewport:Viewport = get_node("SubViewportContainer/Viewport")

@onready var obj_joypads:HBoxContainer = obj_window.get_node("Joypads")
@onready var obj_selection:HBoxContainer = obj_window.get_node("Players")
var ready_players = []

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
		print(event.device)

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
		print(ready_players[id].input_pack)
		players_data[id] = {
			"input_map": ready_players[id].input_pack,
			"skin": ready_players[id].skin
		}
		stats_data[id] = {
			"deaths": 0,
		}
	PartyManager.match_data["players"] = players_data
	PartyManager.match_data["stats"] = stats_data
	GameManager.change_scene("game")

func _on_button_pressed():
	GameManager.change_scene("menu_main")
