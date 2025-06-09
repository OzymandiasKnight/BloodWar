extends Area2D
class_name HitBox

signal hit(hurtbox:HurtBox)

@export var master:Entity

@export_enum("null","invincility","wounded") var effect:String = "null"
##Hundreth seconds added to effect
@export var effect_strenght:int = 20
@export var damage:int = 20
@export var knockback:Vector2 = Vector2(0,0)
##Hit all targets after close_hit()
@export var hit_on_close:bool = false
##Require manual clearing using manual_hit() on true, for delayed attacks
@export var manual_clear:bool

@export var hitbox_debug:bool = false

var hit_reg:bool = false
var hurtboxes_hit:Array = []

var debug_active:int = 0

func _ready():
	connect("area_entered",area_entered)

func _draw():
	if debug_active>0 and hitbox_debug:
		if get_node("Collision"):
			var collision:CollisionShape2D = get_node("Collision")
			var collision_shape:RectangleShape2D = collision.shape
			var siz:Vector2 = Vector2(collision_shape.size.x,collision_shape.size.y)
			var pos:Vector2 = Vector2(collision.position.x-siz.x/2,collision.position.y-siz.y/2)
			draw_rect(Rect2(pos.x,pos.y,siz.x,siz.y),Color(1,0,0,0.35))
		if debug_active==2:

			var debug_timer:Timer = null
			if has_node("Timer"):
				debug_timer = get_node("Timer")
				debug_timer.stop()
			else:
				debug_timer = Timer.new()
				debug_timer.timeout.connect(undraw_debug)
				debug_timer.wait_time = 0.075
				debug_timer.name = "Timer"
				add_child(debug_timer)
			debug_timer.start()

func area_entered(area:Area2D):
	if hit_reg:
		if not (area in hurtboxes_hit):
			if area is HurtBox:
				if area.get_parent() != master:
					if not hit_on_close:
						hit_hurtbox(area)
					hurtboxes_hit.append(area)

func open_hit():
	hit_reg = true
	hurtboxes_hit = []
	draw_debug()
	for area in get_overlapping_areas():
		if area is HurtBox:
			hurtboxes_hit.append(area)
			if not hit_on_close:
				if not manual_clear:
					hit_hurtbox(area)
				
func close_hit():
	hit_reg = false
	
	if hit_on_close:
		for hurtbox in hurtboxes_hit:
			hit_hurtbox(hurtbox)
	if not manual_clear:
		hurtboxes_hit = []
	undraw_debug()

func manual_hit():
	if manual_clear:
		hit_reg = false
		print(hurtboxes_hit)
		for hurtbox in hurtboxes_hit:
			hit_hurtbox(hurtbox)
		hurtboxes_hit = []
		

func instant_hit():
	for node in get_overlapping_areas():
		if node is HurtBox:
			hit_hurtbox(node)
	draw_instant_debug()

func hit_hurtbox(box:HurtBox):
	if box.get_parent() != master:
		box.health_component.add_damage(damage,self)
		box.health_component.add_effect(effect,float(effect_strenght)/100)
		if master is Entity:
			master.set_hit.emit(damage,box)
		emit_signal("hit",box)

func draw_instant_debug():
	debug_active = 2
	queue_redraw()

func draw_debug():
	debug_active = 1
	queue_redraw()

func undraw_debug():
	debug_active = 0
	queue_redraw()
