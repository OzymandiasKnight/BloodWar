extends Area2D
class_name HurtBox


signal damage_taken(damage:int,source:HitBox)
signal damage_blocked(damage:int,source:HitBox)
signal healed(heal:int)
signal died()
signal revived()
signal effect_applied(effect_name:String,time_left:float)
signal effect_cleared(effect_name:String)

@export var health_component:HealthComponent

@export var hurtbox_debug:bool = false

func _ready():
	if hurtbox_debug:
		queue_redraw()
	health_component.hurtbox = self

func _draw() -> void:
	if hurtbox_debug:
		print("draw")
		var collision:CollisionShape2D = get_node("Collision")
		var collision_shape:RectangleShape2D = collision.shape
		var siz:Vector2 = Vector2(collision_shape.size.x,collision_shape.size.y)
		var pos:Vector2 = Vector2(collision.position.x-siz.x/2,collision.position.y-siz.y/2)
		draw_rect(Rect2(pos.x,pos.y,siz.x,siz.y),Color(0,1,0,0.2))
