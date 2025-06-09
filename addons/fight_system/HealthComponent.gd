extends Node
class_name HealthComponent

##Entity Health
@export var health:int = 100
##Percentage of damage reduction
@export var toughness:int = 20

@export var team:String = ""

var hurtbox:HurtBox = null

#Default Health
var base_health:int = 100

var alive:bool = true

#Effects
var base_effects:Dictionary = {
	"INVINCIBILITY": 0.0,
	"WOUNDED": 0.0,
}

#Duration in seconds
var effects:Dictionary = {
}

func _ready():
	effects = base_effects
	base_health = health

func _physics_process(delta):
	for eff in effects.keys():
		if effects[eff] > 0.0:
			effects[eff] = max(0.0,effects[eff]-delta)
		if effects[eff] == 0.0:
			effects.erase(eff)
			hurtbox.effect_cleared.emit(eff)

func add_damage(value:int,source:HitBox=null):
	if alive:
		if !has_effect("invincibility"):
			var cancel:bool = false
			if source:
				cancel = !(team != source.master.health_component.team or team == "")
			if cancel == false:
				var damage:int = round(value*(1-float(toughness)/100))
				health = max(0,health-damage)
				hurtbox.damage_taken.emit(value,source)
				if health == 0:
					die()
		else:
			hurtbox.damage_blocked.emit(value,source)
	
func add_heal(value:int):
	if alive:
		if !has_effect("wounded"):
			health = min(health+value,base_health)

func has_effect(effect_name:String) -> bool:
	effect_name = effect_name.to_upper()
	return effects.has(effect_name)

func set_effect(effect_name:String,value:float):
	effect_name = effect_name.to_upper()
	if effect_name != "NULL":
		if value == 0.0:
			effects.erase(effect_name)
			hurtbox.effect_cleared.emit(effect_name)
		else:
			effects[effect_name] = value
			hurtbox.effect_applied.emit(effect_name,value)

func add_effect(effect_name:String,value:float):
	effect_name = effect_name.to_upper()
	if effect_name != "NULL":
		if effects.has(effect_name):
			effects[effect_name] += value
		else:
			effects[effect_name] = value
		hurtbox.effect_applied.emit(effect_name,effects[effect_name])

func die():
	effects = base_effects
	alive = false
	hurtbox.died.emit()

func revive():
	effects = base_effects
	health = base_health
	alive = true
	hurtbox.revived.emit()
