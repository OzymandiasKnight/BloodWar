extends Control

@onready var obj_icons:HBoxContainer = get_node("Icons")
@onready var obj_action:Label = get_node("Action")

@export var inputs_icons:InputIcon

var player:Player = null

var keys:Dictionary = {
	"res://Textures/Instances/Interfaces/Icons/L2.tres" = "attack",
	"res://Textures/Instances/Interfaces/Icons/L2Pressed.tres" = "attack_pressed",
	"res://Textures/Instances/Interfaces/Icons/R2.tres" = "parry",
	"res://Textures/Instances/Interfaces/Icons/R2Pressed.tres" = "parry_pressed",
	"res://Textures/Instances/Interfaces/Icons/DownButton.tres" = "jump_pressed"
}


func _ready():
	pass

func set_icons():
	var is_keyboard:bool = false
	
	obj_action.text = inputs_icons.name
	for icon in obj_icons.get_children():
		icon.visible = false
	
	for index in range(len(inputs_icons.icons)):
		var icon:Control = obj_icons.get_children()[index]
		var texture:Texture2D = inputs_icons.icons[index]
		if is_keyboard:
			if player:
				var icon_text:String = keys[texture.resource_path]
				var key_text:String = player.input_pack.action_to_input(icon_text)[0]
		icon.get_node("Icon").texture = texture
		icon.visible = true
	
	size.x = 27*len(inputs_icons.icons)
