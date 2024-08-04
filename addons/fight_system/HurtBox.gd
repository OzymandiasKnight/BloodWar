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

func _ready():
	health_component.hurtbox = self
