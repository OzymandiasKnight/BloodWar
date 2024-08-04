extends Entity
class_name Player


signal revive()
signal blocked_hit(damage:int,source:HitBox)

var pre_lance = preload("res://Scenes/Instances/Projectiles/Spear.tscn")

var skin:String = "Blood"

@export var world:LeveLMap
@export var camera:Camera2D
@export var input_pack:InputPack

@export var stat_jump:int = 50
@export var stat_weight:int = 50

@onready var input_box:InputBox = get_node("InputBox")
@onready var state_machine:StateMachine = get_node("StateMachine")
@onready var hurtbox:HurtBox = get_node("HurtBox")

@onready var hud:Control = null

@onready var obj_animations:Node2D = get_node("PlayerAnimations")

@onready var che_ground:RayCast2D = get_node("GroundChecker")
@onready var che_edge:RayCast2D = obj_animations.get_node("EdgeChecker")
@onready var che_floor:RayCast2D = obj_animations.get_node("FloorChecker")

var vel_mov:Vector2 = Vector2(0,0)
var vel_gra:Vector2 = Vector2(0,0)
var vel_tp:Vector2 = Vector2(0,0)
var vel_kb:Vector2 = Vector2(0,0)


var side:int = 0
var side_last:int = 1

func _ready():
	state_machine.set_ready()
	input_box.input_pack = input_pack
	set_hit.connect(steal_health)
	hurtbox.died.connect(died)
	obj_animations.set_colors(skin)
	obj_animations.set_hitboxes(self)

func set_camera(cur_camera:Camera2D):
	var remote_transform:RemoteTransform2D = RemoteTransform2D.new()
	remote_transform.remote_path = cur_camera.get_path()
	add_child(remote_transform)

func _physics_process(_delta):

	if is_on_ground():
		vel_kb.x = lerp(vel_kb.x,0.0,0.1)

		if state_machine.current_state.can_jump:
			if input_box.is_action_just_pressed("jump"):
				jump()
	else:
		if state_machine.current_state.can_fall:
			state_machine.change_state("Fall")

	if vel_tp != Vector2(0,0):
		health_component.add_effect("invincibility",0.05)

	velocity = vel_mov+vel_gra+vel_tp+vel_kb
	
	if is_on_ground():
		vel_kb.y = 0.0
	vel_tp = Vector2(0,0)
	move_and_slide()
	get_node("Label").text = str(state_machine.current_state.name)

func is_on_ground() -> bool:
	return is_on_floor()

func set_side(force_side:int=0):
	if force_side == 0:
		side = int(input_box.is_action_pressed("right"))-int(input_box.is_action_pressed("left"))

	else:
		side = force_side
		side = clamp(side,-1,1)

	if side != 0:
		side_last = side
		obj_animations.scale.x = side_last

func jump():
	state_machine.change_state("Jump")


func _on_state_machine_state_entered(new_state):
	if new_state.entry_animation != "":
		if obj_animations:
			obj_animations.stop_animations()
			obj_animations.play_animation(new_state.entry_animation)

func throw_lance(offset:Vector2):
	var lance:Projectile = pre_lance.instantiate()
	lance.direction = Vector2(side_last,-0.2)
	lance.position = position+offset+Vector2(24*side_last,24)
	lance.hitbox.master = self
	world.add_child(lance)


#Damage Taken
func _on_hurt_box_damage_taken(damage:int,source:HitBox):
	if source:
		set_knockback(damage,source)
	emit_signal("get_hit")

func use_health(value) -> bool:
	if hurtbox.health_component.health > value:
		hurtbox.health_component.add_damage(value)
		emit_signal("get_hit")
		return true
	else:
		return false

func steal_health(value:int):
	var heal:int = int(value*0.2)
	hurtbox.health_component.add_heal(heal)

func set_knockback(damage:int,source:HitBox):
	var direction:Vector2 = (global_position-source.global_position).normalized()
	var force:Vector2 = source.knockback * damage
	
	var knockback:Vector2 = direction * force
	
	knockback.x = abs(knockback.x) * sign(global_position.x-source.global_position.x)
	knockback.y = abs(knockback.y) * sign(global_position.y-source.global_position.y)
	
	
	var kb_dir = abs(vel_kb)*direction
	
	vel_gra = Vector2(0,0)
	
	vel_kb = kb_dir+knockback+(knockback*int(!is_on_ground()))

func _on_hurt_box_died():
	state_machine.change_state("Death")

func reset_velocities():
	vel_mov = Vector2(0,0)
	vel_gra = Vector2(0,0)
	vel_tp = Vector2(0,0)
	vel_kb = Vector2(0,0)

func _on_hurt_box_revived():
	revive.emit()
	reset_velocities()
	state_machine.change_state("Spawn")


func _on_hurt_box_damage_blocked(damage:int,source:HitBox):
	if source:
		if source.master is Player:
			var parried:Player = source.master
			if sign(global_position.x-source.global_position.x) != side_last:
				set_knockback(roundi(float(damage)/4),source)
				parried.hurtbox.health_component.add_effect("wounded",0.1)
				parried.state_machine.change_state("Stun")
				var box = HitBox.new()
				box.master = self
				box.global_position = global_position
				box.knockback = source.knockback
				parried.set_knockback(roundi(float(damage)/2),box)
				blocked_hit.emit(damage,source)
			else:
				hurtbox.health_component.set_effect("invincibility",0.0)
				hurtbox.health_component.add_damage(damage,source)

func is_on_edge() -> Vector2:
	if che_floor.is_colliding() or !(che_edge.is_colliding()):
		return Vector2(0,0)
	else:
		return che_edge.get_collision_point()

func died():
	PartyManager.add_stat(int(str(name)),"deaths",1)
	world.player_died(name)
