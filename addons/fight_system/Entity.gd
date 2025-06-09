extends CharacterBody2D
class_name Entity

signal get_hit(damage:int,source:HitBox)
signal set_hit(damage:int,to:HurtBox)

@export var health_component:HealthComponent = null
