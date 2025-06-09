extends CanvasLayer

@onready var obj_window:Control = get_node("Window")
@onready var obj_gamepad:Node2D = obj_window.get_node("Gamepad")
@onready var obj_gp_left:Sprite2D = obj_gamepad.get_node("Left")
@onready var obj_gp_right:Sprite2D = obj_gamepad.get_node("Right")
@onready var input_box_joypad:InputBox = obj_window.get_node("InputBox")

@onready var obj_viewport:SubViewport = get_node("Container/Viewport")

@onready var text:Label = get_node("Window/Label")

func _ready() -> void:
	obj_viewport.get_parent().visible = true
	obj_window.reparent(obj_viewport)


func _process(delta: float) -> void:
	text.text = "1.2 Left : " + str(Input.get_action_strength("attackc1",true))
	var left_stick:int = int(input_box_joypad.is_action_pressed("right"))-int(input_box_joypad.is_action_pressed("left"))
	obj_gp_left.get_node("Joystick").position.x = 24+left_stick*4
	
	obj_gp_left.get_node("Trigger").visible = input_box_joypad.is_action_pressed("attack")
	obj_gp_right.get_node("Trigger").visible = input_box_joypad.is_action_pressed("parry")
