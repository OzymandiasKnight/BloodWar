extends State
class_name PlayerState

@export var can_fall:bool
@export var can_jump:bool
@export var entry_animation:String


var player:Player = null

func Ready():
	super()
	player = master

func Enter(_old_state:State):
	pass

func Process(_delta:float):
	pass

func PhysicsProcess(_delta:float):
	pass

func Exit(_new_state:String):
	pass

func apply_gravity(scale:float=1.0):
	player.vel_gra.y += player.stat_weight
