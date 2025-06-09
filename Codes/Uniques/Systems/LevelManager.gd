extends Control

var pre_p_screen = preload("res://Scenes/Uniques/Systems/PlayerScreen.tscn")
var pre_player = preload("res://Scenes/Instances/Entities/Player.tscn")
var pre_hud = preload("res://Scenes/Instances/Interfaces/PlayerHUD.tscn")

@export var inputs:InputBox

@export var level:LeveLMap

@onready var obj_screens:Control = get_node("Screens")

var screen_positions:Array[Vector2] = [Vector2(0,0),Vector2(480,0),Vector2(0,270),Vector2(480,270)]

@export var players:Dictionary = {
}

var players_alive:Array[Player] = []

var player_group:Node = Node.new()

@export var rounds:int = 1

var last_winner:Player = null

func _ready():
	rounds = PartyManager.match_data.modifiers["max_rounds"]
	players = PartyManager.match_data["players"]
	
	level.player_die.connect(player_died)
	
	
	setup_scene()
	
	start_game()

func setup_scene():
	for id in players.keys():
		var player:Player = pre_player.instantiate()
		player.name = str(id)
		player.input_pack = players[id]["input_map"]
		player.skin = players[id]["skin"]
		player.world = level
		player_group.add_child(player)
		players_alive.append(player)

	level.add_child(player_group)
	
	for id in players.keys():
		#Set Player Screen
		var p_screen:SubViewportContainer = pre_p_screen.instantiate()
		p_screen.name = str(id)
		obj_screens.add_child(p_screen)
		
		#Set and connect player HUD
		var p_hud = pre_hud.instantiate()
		p_hud.player = player_group.get_node(str(id))
		p_hud.p_color = PartyManager.get_color(get_player_by_id(id).skin,0)
		p_hud.s_color = PartyManager.get_color(get_player_by_id(id).skin,1)
		p_hud.t_color = PartyManager.get_color(get_player_by_id(id).skin,2)
		

		p_screen.add_child(p_hud)
		player_group.get_node(str(id)).hud = p_hud
		
		#Set Player Camera
		player_group.get_node(str(id)).set_camera(p_screen.camera)
		
		
		#Set Viewport Camera
		if id == 0:
			level.reparent(p_screen.viewport)
			level.visible = true
		else:
			p_screen.viewport.world_2d = obj_screens.get_node("0").viewport.world_2d

	set_screens()
	
	if len(players.keys()) == 1:
		obj_screens.get_node("0").scale = Vector2(2,2)

func set_screens():
	var alive_ids:Array[int] = []
	for player in player_group.get_children():
		if player is Player:
			if player.hurtbox.health_component.alive:
				alive_ids.append(int(str(player.name)))
				obj_screens.get_node(str(player.name)).visible = true
			else:
				obj_screens.get_node(str(player.name)).visible = false
	
	var offset:int = 0
	for id in alive_ids:
		obj_screens.get_node(str(id)).position = screen_positions[offset]
		if len(alive_ids) == 2:
			obj_screens.get_node(str(id)).position.y = 135
		
		offset += 1

func player_died(_id):
	var alives = 0
	for player in player_group.get_children():
		if player is Player:
			if player.hurtbox.health_component.alive:
				alives += 1
				if alives == 1:
					last_winner = player
					PartyManager.match_data["stats"][int(str(player.name))]["wins"] += 1
	if alives <= 1:
		if rounds <= 1:
			end_game()
		else:
			rounds -= 1
			get_node("Round").text = str(PartyManager.match_data.modifiers["max_rounds"]-rounds)+"/"+str(PartyManager.match_data.modifiers["max_rounds"])
			start_round()
			set_screens()
	else:
		set_screens()

func start_game():
	start_round()

func start_round():
	level.set_spawns()
	for id in range(player_group.get_child_count()):
		get_player_by_id(id).global_position = level.spawns.get_children()[id-1].global_position
		get_player_by_id(id).hurtbox.health_component.revive()
		get_player_by_id(id).reset_velocities()
		get_player_by_id(id).set_side(-sign(get_player_by_id(id).global_position.x-level.spawns.global_position.x))
		if last_winner:
			var current_round = PartyManager.match_data.modifiers["max_rounds"]-rounds+1
			if current_round == PartyManager.match_data.modifiers["max_rounds"]:
				get_player_by_id(id).hud.announce("FIGHT !",PartyManager.get_color(last_winner.skin,0),"FINAL ROUND " + str(current_round),"fire")
			else:
				get_player_by_id(id).hud.announce("FIGHT !",PartyManager.get_color(last_winner.skin,0),"ROUND " + str(current_round))
		else:
			get_player_by_id(id).hud.announce("FIGHT !")
			
	for node in level.get_children():
		if node is Projectile:
			node.queue_free()

func end_game():
	for player in player_group.get_children():
		player.queue_free()
	GameManager.change_scene("menu_win")

func get_player_by_id(id:int) -> Player:
	if player_group.get_children()[id] is Player:
		return player_group.get_children()[id]
	else:
		return null


func _on_inputs_action_frames_maxed(action_name):
	if action_name == "pause":
		PartyManager.pause(false)
		GameManager.change_scene("menu_characters")


func _on_inputs_action_just_pressed(action_name):
	if action_name == "pause":
		PartyManager.pause(!PartyManager.paused)
		get_node("Animations").stop()
		if get_tree().paused:
			get_node("Animations").play("Pause")
		else:
			get_node("Animations").play_backwards("Pause")
