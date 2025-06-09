extends Node2D

@export var player:Player
@export var camera:Camera2D

@export var ui_inputs:InputBox

@onready var obj_actions:Node2D = get_node("Actions")


var selected_action:int = 0


func _ready():
	player.set_camera(camera)
	player.state_machine.get_state("Spawn").ready_time = 0.2

	for node_id in range(obj_actions.get_child_count()):
		obj_actions.get_children()[node_id].position = Vector2(0,node_id*27)
		obj_actions.get_children()[node_id].visible = true

	play_move("Parry")



func play_move(move_name:String):
	get_node("AnimationInputs").release_all_actions()
	player.health_component.die()
	player.health_component.revive()
	player.global_position = Vector2(0,-25)
	player.hammer_dive = Vector2(0,1)
	player.reset_velocities()
	player.set_side(1)
	get_node("Animations").stop()
	get_node("Animations").play(move_name)


func _on_ui_input_action_just_pressed(action_name):
	obj_actions.get_children()[selected_action].unselect()
	if action_name == "left":
		selected_action = loop_int(obj_actions.get_child_count()-1,selected_action-1)
	elif action_name == "right":
		selected_action = loop_int(obj_actions.get_child_count()-1,selected_action+1)
	elif action_name == "jump":
		selected_action = selected_action
	obj_actions.get_children()[selected_action].select()
	play_move(obj_actions.get_children()[selected_action].name)


func loop_int(lenght:int,pos:int) -> int:
	if pos > lenght:
		return 0
	elif pos < 0:
		return lenght
	else:
		return pos


func _on_input_box_action_just_pressed(action_name):
	if action_name == "pause":
		GameManager.change_scene("menu_main")
