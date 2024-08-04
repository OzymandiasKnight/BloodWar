extends CharacterBody2D
class_name Projectile

##Hitbox for entities detection
@export var hitbox:HitBox
##Hitbox for terrain detection, if detected free self
@export var terrain_box:Area2D

@onready var animation:AnimationPlayer = get_node("Animation")

@export var direction:Vector2 = Vector2(0,0)
@export var speed:float = 0.0
@export var weight:float = 0.0

@export var lifetime:float = 5.0

@export var rotative:bool = false

var timer := Timer.new()

@onready var obj_hitbox:HitBox = get_node("HitBox")
@onready var obj_texture:Sprite2D = get_node("Texture")

func _ready():
	obj_texture.material.set_shader_parameter("replace_p_color",PartyManager.get_color(hitbox.master.skin,0))
	obj_texture.material.set_shader_parameter("replace_s_color",PartyManager.get_color(hitbox.master.skin,1))
	
	
	timer.connect("timeout",kill_self)
	timer.set_wait_time(lifetime)
	add_child(timer)
	hitbox.hit.connect(hitbox_hit)
	terrain_box.body_entered.connect(terrain_body_entered)
	
	scale.x = direction.x
	hitbox.open_hit()
	velocity = direction*speed

	timer.start()

	if animation:
		if animation.has_animation("Deploy"):
			animation.play("Deploy")

func _physics_process(_delta):
	#velocity = direction*speed
	if rotative:
		rotation = Vector2(0,0).angle_to_point(velocity)
	velocity.y += weight
	move_and_slide()

func kill_self():
	timer.stop()
	hitbox.close_hit()
	velocity = velocity.normalized()
	
	if animation:
		if animation.has_animation("Destroy"):
			animation.play("Destroy")
	else:
		queue_free()
	

func hitbox_hit(hurtbox:HurtBox):
	if hurtbox.health_component.alive:
		kill_self()


func terrain_body_entered(body):
	if body is TileMap:
		kill_self()
