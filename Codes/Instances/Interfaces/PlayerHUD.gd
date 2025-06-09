extends Control

var player:Player

@onready var obj_health_bar:TextureProgressBar = get_node("HealthBar")
@onready var obj_health_bar_bg:Sprite2D = get_node("HealthBarBackground")
@onready var obj_announcement:AnimationPlayer = get_node("Animation")
@onready var obj_health_effect:Sprite2D = obj_health_bar_bg.get_node("Wounded")
@onready var obj_borders:Sprite2D = get_node("Borders")
@onready var obj_combo:Node2D = get_node("TremorNode/Combo")


@export var p_color:Color = Color.GRAY
@export var s_color:Color = Color.WHITE
@export var t_color:Color = Color.WHITE

@onready var obj_action_indicators:HBoxContainer = get_node("ActionIndicators")


func _ready():
	player.get_hit.connect(get_hit)
	player.revive.connect(update_health)
	
	player.set_hit.connect(set_hit)
	player.hurtbox.damage_blocked.connect(set_hit)
	
	
	player.hurtbox.effect_applied.connect(effect_applied)
	player.hurtbox.effect_cleared.connect(effect_cleared)
	
	#Set Default Health bar
	obj_health_bar.max_value = player.hurtbox.health_component.base_health
	obj_health_bar.value = player.hurtbox.health_component.health
	
	set_color()
	
	player.state_machine.state_entered.connect(player_entered_state)

func set_hit(value,_to:HurtBox):
	update_health()
	play_combo(value)

func block_hit(value,_to:HurtBox):
	play_combo(value)

func play_combo(value):
	obj_combo.get_node("Animation").stop()
	obj_combo.get_node("Animation").play("HIT")
	obj_combo.get_node("Number").text = str(player.combo)
	obj_combo.get_parent().add_tremor(value)

func get_hit(_value,_source):
	update_health()

func update_health():
	obj_health_bar.value = player.hurtbox.health_component.health

func announce(text:String,color:Color=Color.WHITE,sub_title:String="",animation:String=""):
	animation = animation.to_lower()
	get_node("Announcement").get_node("Text").text = text
	get_node("Announcement").get_node("Sub").text = sub_title
	get_node("Announcement").self_modulate = color
	get_node("Announcement/Shadow").self_modulate = color
	obj_announcement.stop()
	if animation == "fire":
		get_node("Announcement/Fire").material.set_shader_parameter("p_color",color)
		obj_announcement.play("FireAnnouncement")
	else:
		obj_announcement.play("Announcement")
	

func set_color():
	obj_health_bar.modulate = p_color
	obj_health_bar_bg.self_modulate = s_color
	obj_borders.modulate = p_color
	obj_health_effect.modulate = t_color
	

func effect_applied(effect_name:String,_time:float):
	if effect_name == "WOUNDED":
		obj_health_effect.visible = true

func effect_cleared(effect_name:String):
	if effect_name == "WOUNDED":
		obj_health_effect.visible = false

func player_entered_state(new_state:PlayerState):
	var player_state:PlayerState = new_state
	for indicator in obj_action_indicators.get_children():
		indicator.visible = false
	
	for index in range(len(player_state.possible_inputs)):
		obj_action_indicators.get_children()[index].inputs_icons = player_state.possible_inputs[index]
		obj_action_indicators.get_children()[index].set_icons()
		obj_action_indicators.get_children()[index].visible = true
