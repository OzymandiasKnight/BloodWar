extends Node2D

var p_color:Color = Color.RED
var s_color:Color = Color.YELLOW

@onready var obj_animations:AnimationPlayer = get_node("Animations")

@onready var obj_hitboxes:Node2D = get_node("HitBoxes")
@onready var obj_lance_offset:Marker2D = obj_hitboxes.get_node("Lance")

@onready var obj_top:Sprite2D = get_node("Top")

func play_animation(animation_name:String):
	obj_animations.play(animation_name)

func stop_animations():
	obj_animations.stop()

func throw_lance():
	get_parent().throw_lance(obj_lance_offset.position)

func set_colors(skin):
	material.set_shader_parameter("replace_p_color",PartyManager.get_color(skin,0))
	material.set_shader_parameter("replace_s_color",PartyManager.get_color(skin,1))
	material.set_shader_parameter("replace_t_color",PartyManager.get_color(skin,2))

func set_hitboxes(player:Player):
	for node in obj_hitboxes.get_children():
		if node is HitBox:
			node.master = player

func teleport(distance:Vector2):
	get_parent().vel_tp = Vector2(distance.x*get_parent().side_last,distance.y)*50
