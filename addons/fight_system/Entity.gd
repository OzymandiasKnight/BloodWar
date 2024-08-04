extends CharacterBody2D
class_name Entity

signal get_hit(damage:int,source:Player)
signal set_hit(damage:int)

@export var health_component:HealthComponent = null
