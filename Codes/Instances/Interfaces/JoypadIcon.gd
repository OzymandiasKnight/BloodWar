extends Control

@onready var obj_animation:AnimationPlayer = get_node("Animation")

func joy_connect():
	visible = true
	obj_animation.play("Connect")

func joy_disconnect():
	visible = false
