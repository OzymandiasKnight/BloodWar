extends ColorRect

signal player_entered(player:Player,zone_name:String)

@onready var obj_area:Area2D = get_node("Area")
@onready var obj_collision:CollisionShape2D = obj_area.get_node("Collision")

var enabled:bool = false

func _ready() -> void:
	var shape:RectangleShape2D = RectangleShape2D.new()
	shape.size.x = size.x
	shape.size.y = size.y
	
	obj_collision.shape = shape
	obj_area.position = size/2.0
	var texture := NoiseTexture2D.new()
	texture.width = size.x*5.0
	texture.height = size.y*5.0
	texture.seamless = true
	texture.noise = FastNoiseLite.new()
	material.set_shader_parameter("noise",texture)
	

func unshow():
	get_node("Animation").play("Hide")
	enabled = false

func unhide():
	enabled = true
	get_node("Animation").play("Show")

func _on_area_area_entered(area: Area2D) -> void:
	if enabled:
		if area is HurtBox:
			if area.get_parent() is Player:
				player_entered.emit(area.get_parent(),name)
