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

var hit_reg:bool = false
var hurtboxes_hit:Array[HurtBox] = []

func _ready():
	connect("area_entered",area_entered)

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
	for area in get_overlapping_areas():
		if area is HurtBox:
			if area.get_parent() != master:
				hurtboxes_hit.append(area)
				
func close_hit():
	hit_reg = false
	
	if hit_on_close:
		for hurtbox in hurtboxes_hit:
			hit_hurtbox(hurtbox)
	if not manual_clear:
		hurtboxes_hit = []

func manual_hit():
	if manual_clear:
		hit_reg = false
		for hurtbox in hurtboxes_hit:
			hit_hurtbox(hurtbox)
		print(hurtboxes_hit)
		hurtboxes_hit = []

func instant_hit():
	for node in get_overlapping_areas():
		if node is HurtBox:
			if node.get_parent() != master:
				hit_hurtbox(node)
			

func hit_hurtbox(box:HurtBox):
	if box.get_parent() != master:
		box.health_component.add_damage(damage,self)
		box.health_component.add_effect(effect,float(effect_strenght)/100)
		if master is Entity:
			master.set_hit.emit(damage)
		emit_signal("hit",box)
