extends Node2D

@export var player:Player
@export var camera:Camera2D


var current_phase:int = -1

var default_states:Array = ["Idle","Walk","Run","Jump","Fall","Stun"]
var attack_states:Array= ["WalkKick","StraightPunch","DownPunch","Parry"]
var bloody_states:Array = ["Teleport","Throw","BatHit","DashSlash","HammerDive"]

var all_states:Array = []

var phases:Dictionary = {
	0: {
		"message": "Walk",
		"zone": "WalkZone",
		"states": ["Fall","Idle","Walk"]
	},
	1: {
		"message": "Run",
		"states": ["Fall","Idle","Walk","Run"]
	},
	2: {
		"message": "Jump",
		"zone": "JumpZone",
		"states": ["Fall","Idle","Walk","Run","Jump"]
	},
	3: {
		"message": "Grab Edge",
		"states": ["Fall","Idle","Walk","Run","Jump","Edge"]
	},
	4: {
		"message": "Jump off the edge",
		"states": ["Jump"]
	},
	5: {
		"message": "Parry the ennemy attack",
		"states": ["Fall","Idle","Walk","Run","Jump","Edge","Parry"],
		"parries": 0,
	},
	6: {
		"message": "Perform a high kick",
		"states": ["Fall","Idle","Walk","Run","Jump","Edge","WalkKick"],
		"kicks": 0,
	}
}

@onready var obj_defence_bot:Player = get_node("Container/Viewport/DefenceBot")
@onready var obj_message:Label = get_node("Message")

func _ready():
	all_states = default_states
	all_states.append_array(attack_states)
	all_states.append_array(bloody_states)
	obj_defence_bot.health_component.add_effect("invincibility",-1)
	obj_defence_bot.health_component.toughness = 100
	obj_defence_bot.set_side(-1)
	player.set_camera(camera)
	player.state_machine.get_state("Spawn").ready_time = 0.2
	player.state_machine.state_entered.connect(player_state_entered)
	player.blocked_hit.connect(player_blocked_hit)
	player.set_hit.connect(player_set_hit)
	
	for tutorial_zone in player.world.get_node("TriggerZones").get_children():
		tutorial_zone.player_entered.connect(player_entered_zone)
		tutorial_zone.unshow()
	next_phase()

func next_phase():
	current_phase += 1
	if phases.has(current_phase):
		if phases[current_phase].has("zone"):
			player.world.get_node("TriggerZones").get_node(phases[current_phase]["zone"]).unhide()
		player.state_machine.restricted_states = subtractArray(phases[current_phase]["states"],all_states)
		print(player.state_machine.restricted_states)
		obj_message.text = phases[current_phase]["message"]

func player_blocked_hit(damage:int,hitbox:HitBox):
	obj_defence_bot.get_node("AnimationBox/Animation").play("GoBack")
	if current_phase == 5:
		if phases[5]["parries"] >= 2:
			next_phase()
		else:
			phases[5]["parries"] += 1
			obj_message.text = phases[5]["message"] + " (" + str(phases[5]["parries"]) + "/3)"

func player_set_hit(damage:int,to:HurtBox):
	print("HIT")
	if current_phase == 6:
		if phases[6]["kicks"] >= 3:
			next_phase()
		else:
			phases[6]["kicks"] += 1
			obj_message.text = phases[6]["message"] + " (" + str(phases[6]["kicks"]) + "/3)"

func player_state_entered(state:State):
	var state_name:String = state.name
	if current_phase == 1:
		if state_name == "Run":
			next_phase()
	if current_phase == 3:
		if state_name == "Edge":
			next_phase()
	if current_phase == 4:
		if state_name == "Jump":
			next_phase()
	
func player_entered_zone(player:Player,zone:String):
	print(zone)
	if current_phase == 0:
		if zone == "WalkZone":
			next_phase()
	if current_phase == 2:
		if zone == "JumpZone":
			next_phase()
	
	player.world.get_node("TriggerZones").get_node(zone).unshow()

func _on_tutorial_player_die(id: Variant) -> void:
	player.health_component.revive()
	player.global_position = player.world.spawns.global_position



func subtractArray(what : Array, from : Array) -> Array:
	var final_array:Array = from
	for element in what:
		final_array.erase(element)
	
	return final_array
