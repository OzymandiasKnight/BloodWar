extends Control

var player:Player

@onready var obj_health_bar:TextureProgressBar = get_node("HealthBar")
@onready var obj_health_bar_bg:Sprite2D = get_node("HealthBarBackground")
@onready var obj_announcement:AnimationPlayer = get_node("Animation")


@export var p_color:Color = Color.BLACK
@export var s_color:Color = Color.WHITE

func _ready():
	player.get_hit.connect(update_health)
	player.revive.connect(update_health)
	
	player.set_hit.connect(set_hit)
	
	
	#Set Default Health bar
	obj_health_bar.max_value = player.hurtbox.health_component.base_health
	obj_health_bar.value = player.hurtbox.health_component.health
	
	set_color()

func set_hit(_value):
	update_health()

func update_health():
	obj_health_bar.value = player.hurtbox.health_component.health

func announce(text:String,color:Color=Color.WHITE):
	print(color)
	get_node("Announcement").get_node("Text").text = text
	get_node("Announcement").self_modulate = color
	get_node("Announcement/Shadow").self_modulate = color
	
	obj_announcement.stop()
	obj_announcement.play("Announcement")

func set_color():
	obj_health_bar.modulate = p_color
	obj_health_bar_bg.modulate = s_color
	get_node("Borders").modulate = p_color
