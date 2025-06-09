extends CanvasLayer

@onready var obj_viewport:SubViewport = get_node("Container/Viewport")
@onready var obj_window:Control = get_node("Window")
@onready var obj_buttons:VBoxContainer = obj_window.get_node("Buttons")

func _ready():
	obj_window.reparent(obj_viewport)


func _on_play_pressed():
	PartyManager.match_data["modifiers"]["hitbox_debug"] = false
	GameManager.change_scene("menu_characters")


func _on_help_pressed():
	PartyManager.match_data["modifiers"]["hitbox_debug"] = true
	GameManager.change_scene("menu_moves")
