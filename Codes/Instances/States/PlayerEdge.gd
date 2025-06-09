extends PlayerState

@export var offset:Vector2 = Vector2(12,24)
@export var use_cost:int = 15

var base_speed:float = 0

var on_platform:bool = false

var timer_hold:Timer = Timer.new()

func Ready():
	super()
	timer_hold.wait_time = 5.0
	timer_hold.timeout.connect(slip)
	add_child(timer_hold)
	player.get_hit.connect(get_hit)


func Enter(_state):

	player.reset_velocities()
	base_speed = player.vel_mov.x
	on_platform = player.che_platform.is_colliding()
	
	if on_platform:
		player.obj_animations.play_animation("Platform")
		player.global_position = player.is_on_edge()+Vector2(0,offset.y+4)
	else:
		timer_hold.start()
		player.obj_animations.play_animation("Edge")
		player.global_position = player.is_on_edge()+Vector2(-offset.x*player.side_last,offset.y)

	
	
	player.che_edge.enabled = false

func PhysicsProcess(_delta:float):
	if player.input_box.is_action_just_pressed("jump"):
		machine.change_state("Jump")
	elif player.input_box.is_action_pressed("parry"):
		if player.input_box.is_action_just_pressed("attack"):
			if player.use_health(use_cost):
				machine.change_state("BatHit")

func slip():
	machine.change_state("Fall")

func Exit(_new_state):
	timer_hold.stop()
	if on_platform:
		player.obj_animations.play_sprite_particle("BloodyPickaxe")
	else:
		player.obj_animations.play_sprite_particle("BloodyAxe")
	player.che_edge.enabled = true
	player.che_edge.force_raycast_update()
	player.vel_mov.x = base_speed

func get_hit(_a,_b):
	if is_current():
		machine.change_state("Stun")
