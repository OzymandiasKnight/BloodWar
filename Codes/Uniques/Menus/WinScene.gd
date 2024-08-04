extends CanvasLayer

@onready var obj_window:Control = get_node("Window")
@onready var obj_viewport:SubViewport = get_node("Container/Viewport")

@onready var obj_winner_card:Node2D = obj_window.get_node("PlayerCard")

func _ready():
	obj_window.reparent(obj_viewport)
	var win_d:int = 10
	var win_id:int = 0
	var stats:Dictionary = PartyManager.match_data["stats"]
	for player in stats.keys():
		if stats[player]["deaths"] < win_d:
			win_d = stats[player]["deaths"]
			win_id = player
	
	var winner:Dictionary = PartyManager.match_data["players"][win_id]
	obj_winner_card.skin = winner["skin"]
	obj_winner_card.set_colors()


func _on_button_pressed():
	GameManager.change_scene("menu_main")
