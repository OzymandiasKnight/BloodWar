extends Node2D

var skin:String = "Blood"

@onready var obj_character:Sprite2D = get_node("Panel")

func _ready():
	set_colors()

func set_colors():
	obj_character.material.set_shader_parameter("replace_p_color",PartyManager.get_color(skin,0))
	obj_character.material.set_shader_parameter("replace_s_color",PartyManager.get_color(skin,1))
	
