extends CanvasLayer

var pre_player_card = preload("res://Scenes/Instances/Interfaces/PlayerCard.tscn")

@export var spacing:int = 125

@onready var obj_window:Control = get_node("Window")
@onready var obj_viewport:SubViewport = get_node("Container/Viewport")

@onready var obj_players = obj_window.get_node("Players")

func _ready():
	obj_window.reparent(obj_viewport)
	var win_d:int = 10
	var win_id:int = 0
	var stats:Dictionary = PartyManager.match_data["stats"]
	var game:Dictionary = PartyManager.match_data["players"]
	var off:int = 0
	var player_number:int = len(stats.keys())
	print(player_number)
	for player in stats.keys():
		var player_card:Node2D = pre_player_card.instantiate()
		player_card.skin = game[player]["skin"]
		print(game[player]["skin"])
		player_card.position.x = round(off*spacing-(float(player_number)/2.0)*spacing+(float(spacing)/2.0))
		player_card.name = str(player)
		#Stats
		player_card.set_stats(stats[player])
		
		obj_players.add_child(player_card)
		player_card.set_colors()
		if stats[player]["deaths"] < win_d:
			win_d = stats[player]["deaths"]
			win_id = player
		off += 1
	obj_players.get_node(str(win_id)).position.y = -30
	


func _on_home_pressed():
	GameManager.change_scene("menu_main")
