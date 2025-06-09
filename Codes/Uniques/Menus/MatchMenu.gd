extends Node2D

@onready var obj_window:Control = get_node("Window")
@onready var obj_viewport:SubViewport = get_node("Container/Viewport")

func _ready():
	obj_window.reparent(obj_viewport)
