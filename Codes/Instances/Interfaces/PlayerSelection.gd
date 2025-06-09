extends Control

signal set_ready()

@export var controller_id:int = -1

@export var input_pack:InputPack

@onready var obj_inputs:InputBox = get_node("InputBox")

@onready var obj_animations:AnimationPlayer = get_node("Animation")

@onready var obj_skin_name:Label = get_node("SkinName")

var joined:bool = false

var skin:String = "Blood"
var skin_id:int = 0

var skin_choices:Array[String] = ["Blood","Fire","Thunder","Poison","Ice","Dimension","Void","Ink","Cloud"]

var is_ready:bool = false

@onready var obj_card:Node2D = get_node("Card")
@onready var obj_character:Sprite2D = obj_card.get_node("Offset/Panel")
@onready var obj_wave:ColorRect = obj_card.get_node("Wave")


func _ready():

	if not input_pack:
		if controller_id != -1:
			input_pack = PartyManager.get_controller_pack(controller_id)
	if input_pack:
		obj_inputs.input_pack = input_pack
	visible = false
	set_colors()


func _on_input_box_action_just_pressed(action_name):
	if visible:
		if action_name == "jump":
			if not is_ready:
				leave()
			else:
				play_animation("LeaveLocked")
		else:
			if not is_ready:
				if action_name == "left":
					skin_id = loop_int(len(skin_choices)-1,skin_id-1)
				elif action_name == "right":
					skin_id = loop_int(len(skin_choices)-1,skin_id+1)
			if (obj_inputs.is_action_pressed("parry") and obj_inputs.is_action_pressed("attack")):
				is_ready = !is_ready
				if is_ready:
					play_animation("Lock")
					get_parent().get_parent().get_parent().get_parent().get_parent().player_lock(self)
					emit_signal("set_ready")
				else:
					obj_animations.play_backwards("Lock")
					get_parent().get_parent().get_parent().get_parent().get_parent().player_unlock(self)
					
			else:
				play_animation("Input")
			skin = skin_choices[skin_id]
			set_colors()
			obj_character.queue_redraw()
			obj_skin_name.text = skin
	else:
		join()

func play_animation(anim_name:String):
	obj_animations.play(anim_name)

func join():
	var players_in:int = 0
	for player in get_parent().get_children():
		if player.visible:
			players_in += 1
	if players_in < 4:
		play_animation("Join")
	get_parent().get_parent().get_parent().get_parent().get_parent().player_joined(self)

func leave():
	get_parent().get_parent().get_parent().get_parent().get_parent().player_leave(self)
	is_ready = false
	if visible:
		play_animation("Leave")

func loop_int(lenght:int,pos:int) -> int:
	if pos > lenght:
		return 0
	elif pos < 0:
		return lenght
	else:
		return pos
		
func get_color(id:int) -> Color:
	return PartyManager.get_color(skin,id)

func set_colors():
	var p_color:Color = get_color(0)
	var s_color:Color = get_color(1)
	var t_color:Color = get_color(2)
	
	obj_character.material.set_shader_parameter("replace_p_color",p_color)
	obj_wave.color = s_color
	obj_wave.material.set_shader_parameter("foam",p_color)
	obj_character.material.set_shader_parameter("replace_s_color",s_color)
	obj_card.get_node("Offset/Border").modulate = p_color
	obj_card.get_node("Offset/Background").modulate = p_color
	obj_card.get_node("Offset/Background/Effect").material.set_shader_parameter("p_color",s_color)
	obj_card.get_node("Offset/Background/Effect").material.set_shader_parameter("s_color",t_color)
	
	
