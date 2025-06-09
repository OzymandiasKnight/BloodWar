extends Node2D

var p_color:Color = Color.RED
var s_color:Color = Color.YELLOW

@onready var obj_animations:AnimationPlayer = get_node("Animations")

@onready var obj_hitboxes:Node2D = get_node("HitBoxes")
@onready var obj_particles:Node2D = get_node("Particles")
@onready var obj_lance_offset:Marker2D = obj_hitboxes.get_node("Lance")

@onready var obj_top:Sprite2D = get_node("Top")
@onready var obj_bottom:Sprite2D = get_node("Bottom")

@onready var obj_checks:Node2D = get_node("Checks")

var player:Player = null

func _ready():
	player = get_parent().get_parent()
	obj_top.get_node("Outline").visible = true
	obj_top.get_node("Outline").hframes = obj_top.hframes
	obj_top.get_node("Outline").vframes = obj_top.vframes
	
	obj_bottom.get_node("Outline").visible = true
	obj_bottom.get_node("Outline").hframes = obj_bottom.hframes
	obj_bottom.get_node("Outline").vframes = obj_bottom.vframes
	

func play_animation(animation_name:String):
	obj_animations.play(animation_name)

func stop_animations():
	obj_animations.stop()

func throw_lance():
	player.throw_lance(obj_lance_offset.position)

func set_colors(skin:String):
	material.set_shader_parameter("replace_p_color",PartyManager.get_color(skin,0))
	material.set_shader_parameter("replace_s_color",PartyManager.get_color(skin,1))
	material.set_shader_parameter("replace_t_color",PartyManager.get_color(skin,2))

func set_outline(is_outline:bool,color=Color.BLACK):
	obj_bottom.get_node("Outline").material.set_shader_paraameter("active",is_outline)
	obj_bottom.get_node("Outline").material.set_shader_paraameter("outline_color",color)
	
	obj_top.get_node("Outline").material.set_shader_paraameter("active",is_outline)
	obj_top.get_node("Outline").material.set_shader_paraameter("outline_color",color)

func get_particle(particle_name) -> SpriteParticle:
	if obj_particles.has_node(particle_name):
		if obj_particles.get_node(particle_name).use_parent_material:
			obj_particles.get_node(particle_name).material = material
		return obj_particles.get_node(particle_name)
	else:
		return null

func set_hitboxes(play:Player):
	for node in obj_hitboxes.get_children():
		if node is HitBox:
			node.master = play
			node.hitbox_debug = PartyManager.match_data["modifiers"]["hitbox_debug"]

func play_sprite_particle(particle_name:String):
	if player.world:
		if obj_particles.get_node(particle_name).use_parent_material:
			obj_particles.get_node(particle_name).material = material
		player.world.play_particle(obj_particles.get_node(particle_name))

func teleport(distance:Vector2):
	player.vel_tp = Vector2(distance.x*player.side_last,distance.y)

func set_hammer_portal():
	play_sprite_particle("PortalSplash")
	player.hammer_dive = Vector2(player.global_position.x,-1920)

func use_hammer_portal():
	player.global_position = player.hammer_dive
	player.hammer_dive = Vector2(0,1)
	player.state_machine.get_state("HammerDive").diving = true
	play_sprite_particle("GroundPortal")

func _on_bottom_frame_changed():
	obj_bottom.get_node("Outline").frame = obj_bottom.frame


func _on_top_frame_changed():
	obj_top.get_node("Outline").frame = obj_top.frame

func get_check(check_name:String) -> Area2D:
	return obj_checks.get_node(check_name)

func side_changed():
	get_check("HammerCollision").monitoring = false
	get_check("HammerCollision").monitoring = true
	
