extends Node2D

var skin:String = "Blood"

@onready var obj_character:Sprite2D = get_node("Panel")

var pre_label_settings = preload("res://Ressources/Uniques/Themes/OutlineText.tres")

var pre_icon = preload("res://Scenes/Instances/Interfaces/Icon.tscn")
var icons_ids:Dictionary = {
	"deaths": preload("res://Textures/Instances/Interfaces/Icons/DeathIcon.tres"),
	"wins": preload("res://Textures/Instances/Interfaces/Icons/WinIcon.tres"),
	"damage": preload("res://Textures/Instances/Interfaces/Icons/DamageIcon.tres"),
	"damage_taken": preload("res://Textures/Instances/Interfaces/Icons/DamageTankIcon.tres"),
}

func _ready():
	set_colors()

func set_colors():
	obj_character.material.set_shader_parameter("replace_p_color",PartyManager.get_color(skin,0))
	obj_character.material.set_shader_parameter("replace_s_color",PartyManager.get_color(skin,1))
	
func set_stats(stats:Dictionary):
	var offset = 0
	for key in stats.keys():
		var height = 15
		var control := Control.new()
		control.custom_minimum_size = Vector2(height*3,height)
		control.name = key
		var label := Label.new()
		label.text = str(stats[key])
		label.position = Vector2(height,0)
		label.label_settings = pre_label_settings
		label.anchors_preset = Control.PRESET_FULL_RECT
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		var icon = pre_icon.instantiate()
		icon.get_node("Texture").texture = icons_ids[key]
		control.position.x = offset%2*control.custom_minimum_size.x
		control.position.y = floor(offset/2.0)*height
		get_node("Stats").add_child(control)
		control.add_child(icon)
		control.add_child(label)
		offset += 1
	
	
