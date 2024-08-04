extends Node2D
class_name LeveLMap

signal player_die(id)

@export var spawns:Node2D

var player_spawns:Array[Vector2] = []

func _ready():
	pass#set_spawns()

func player_died(id):
	player_die.emit(id)

func set_spawns():
	var list:Array[Vector2] = []
	for node in spawns.get_children():
		
		list.append(node.global_position)
	
	#End Function
	#ray_cast.queue_free()
	player_spawns = list
	
	#print(player_spawns)
