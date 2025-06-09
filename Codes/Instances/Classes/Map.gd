extends Node2D
class_name LeveLMap

signal player_die(id)

@export var spawns:Node2D
@export var world_pit:Area2D


var player_spawns:Array[Vector2] = []
var world_roof := StaticBody2D.new()
var world_border := StaticBody2D.new()

func _ready():
	var roof_collision := CollisionShape2D.new()
	var collision_shape := WorldBoundaryShape2D.new()
	collision_shape.distance = -1080.0
	collision_shape.normal = Vector2(0,1)
	roof_collision.shape = collision_shape
	world_roof.collision_layer = 2
	add_child(world_roof)
	world_roof.add_child(roof_collision)
	
	#Border Setup
	var border_collision := CollisionShape2D.new()
	border_collision.position = Vector2(-1920,0)
	var border_shape := RectangleShape2D.new()
	border_shape.size = Vector2(48,2160)
	border_collision.shape = border_shape
	world_border.collision_layer = 3
	world_border.name = "LeftBorder"
	#Left Border
	world_border.position.x = -1080.0*1.75
	world_border.position.x -= border_shape.size.x
	add_child(world_border)
	world_border.add_child(border_collision)
	border_collision.position = Vector2(0,0)
	
	#Right Border
	var second_border:StaticBody2D = world_border.duplicate()
	second_border.name = "RightBorder"
	second_border.position.x *= -1
	add_child(second_border)
	
	
	var rect := ColorRect.new()
	rect.color = Color("78d7ff")
	rect.z_index = -5
	rect.size = Vector2(3840,2160)
	rect.position = Vector2(-1920,-1080)
	rect.modulate = Color(0.8,0.8,0.8)
	rect.material = preload("res://Ressources/Uniques/Shaders/BlueSky.tres")
	add_child(rect)
	world_pit.area_entered.connect(player_out)
	
	for child in get_children():
		if child is BreakableProp:
			child.world = self

func player_died(id):
	player_die.emit(id)

func set_spawns():
	var list:Array[Vector2] = []
	for node in spawns.get_children():
		
		list.append(node.global_position)
	
	#End Function
	#ray_cast.queue_free()
	player_spawns = list
	

func get_world_border(direction:Vector2):
	if direction == Vector2(0,1):
		return world_roof.get_node("Collision").shape.distance

func player_out(area:Area2D):
	if area is HurtBox:
		area.health_component.die()

func play_particle(original_particle:SpriteParticle):
	if original_particle:
		if original_particle.particle_interval == 0.0 or original_particle.interval_timer.time_left == 0.0:
			if original_particle.particle_interval > 0.0:
				original_particle.interval_timer.start()
				
			var particle:SpriteParticle = original_particle.duplicate()
			particle.use_parent_material = false
			particle.global_position = original_particle.global_position
			particle.visible = true
			particle.activate()
			add_child(particle)
