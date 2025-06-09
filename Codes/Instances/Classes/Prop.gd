extends Entity
class_name BreakableProp

##If hard, players get stun by hitting it
@export var hard:bool = false
@export var hurtbox:HurtBox
@export var destroy_particles_parent:Node2D
@export var hit_particles_parent:Node2D

@onready var obj_normal:Node2D = get_node("Normal")
@onready var obj_broken:Node2D = get_node("Destroyed")

var world:LeveLMap = null

func _ready():
	if hard:
		health_component.add_effect("invincibility",250)
	
	for node in get_children():
		if node is CollisionShape2D:
			if node.get_meta("destroyed"):
				node.disabled = true
			else:
				node.disabled = false
	
	obj_broken.visible = false
	obj_normal.visible = true
	health_component.hurtbox.died.connect(broked)
	health_component.hurtbox.damage_taken.connect(damage_taken)
	health_component.hurtbox.damage_blocked.connect(damage_blocked)

func damage_blocked(value:int,source:HitBox):
	play_hit_particles(source)
	health_component.set_effect("invincibility",0.0)
	health_component.add_damage(value,null)
	health_component.add_effect("invincibility",250.0)
	if source.master is Player:
		var stunned:Player = source.master
		var hitbox:= HitBox.new()
		hitbox.global_position = global_position
		hitbox.damage = 0
		hitbox.knockback = Vector2(health_component.toughness,0)
		stunned.set_knockback(health_component.toughness,hitbox)
		stunned.state_machine.change_state("Stun")

func damage_taken(value:int,source:HitBox):
	play_hit_particles(source)

func play_hit_particles(source:HitBox):
	if hit_particles_parent:
		for node in hit_particles_parent.get_children():
			if node is SpriteParticle:
				print(source)
				if source:
					node.scale.x = -sign(global_position.x-source.global_position.x)
				world.play_particle(node)

func broked():
	hurtbox.get_children()[0].disabled = true
	for node in get_children():
		if node is CollisionShape2D:
			if not node.get_meta("destroyed"):
				node.disabled = true
			else:
				node.disabled = false
	obj_normal.visible = false
	for particle in destroy_particles_parent.get_children():
		if particle is SpriteParticle:
			world.play_particle(particle)
	obj_broken.visible = true
