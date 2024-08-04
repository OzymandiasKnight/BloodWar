extends Node2D

func _ready():
	pass


func _on_fight_pressed():
	GameManager.change_scene("menu_characters")
