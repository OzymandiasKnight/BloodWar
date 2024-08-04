@tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("GameManager","res://addons/platformer_system/GameManager.tscn")

func _exit_tree():
	remove_autoload_singleton("GameManager")
