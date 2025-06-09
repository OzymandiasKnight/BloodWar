extends Node2D

@export var action_name:String

func _ready():
	get_node("Offset/Text").text = action_name

func select():
	get_node("Animation").play("Select")

func unselect():
	get_node("Animation").play_backwards("Select")
