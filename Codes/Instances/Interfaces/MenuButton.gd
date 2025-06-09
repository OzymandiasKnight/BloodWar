extends Control

signal pressed()

@export var texture:Texture2D
@export var texture_hold:Texture2D
@export var texture_pressed:Texture2D

@onready var obj_texture:Sprite2D = get_node("Texture")

@export var label_offset:int = 2
@export var label:String = ""

@onready var obj_animation:AnimationPlayer = get_node("Animations")
@onready var obj_text:Label = get_node("Text")

var hold:bool = false

func _ready():
	mouse_entered.connect(on_mouse_entered)
	mouse_exited.connect(on_mouse_exited)
	gui_input.connect(input)
	obj_text.text = label
	obj_text.position.y = 0
	obj_texture.texture = texture
	custom_minimum_size.y = texture.get_size().y-2

func input(event:InputEvent):
	if event is InputEventMouseButton and hold:
		emit_signal("pressed")

func on_mouse_entered():
	obj_texture.texture = texture_hold
	obj_text.position.y = label_offset
	hold = true
	obj_animation.play("Hold")

func on_mouse_exited():
	obj_texture.texture = texture
	obj_text.position.y = 0
	hold = false
	obj_animation.play_backwards("Hold")
