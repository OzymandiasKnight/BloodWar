extends  PlayerState


var timer_placing:Timer = Timer.new()
var timer_teleport:Timer = Timer.new()
var timer_hit:Timer = Timer.new()
var pre_timer_hit:Timer = Timer.new()
@export var placing_time:float = 0.6
@export var teleporting_time:float = 0.3
@export var hit_time:float = 0.3

var diving:bool = false

func Ready():
	super()
	player.set_hit.connect(hit_player)
	player.get_hit.connect(get_hit)
	timer_placing.timeout.connect(portal_placed)
	timer_placing.set_wait_time(placing_time)
	add_child(timer_placing)
	timer_teleport.set_wait_time(teleporting_time)
	timer_teleport.timeout.connect(teleported)
	add_child(timer_teleport)
	timer_hit.set_wait_time(hit_time)
	timer_hit.timeout.connect(quit_dive)
	add_child(timer_hit)
	pre_timer_hit.set_wait_time(0.2)
	pre_timer_hit.timeout.connect(pre_hit)
	add_child(pre_timer_hit)
	
	

func Enter(_old_state):
	player.vel_mov.x = 0
	if player.hammer_dive.y < 0:
		#Activate Hammer Dive
		#Player fall from the sky
		player.obj_animations.play_animation("UsePortal")
		player.reset_velocities()
		timer_teleport.start()
	else:
		timer_placing.start()
		player.obj_animations.play_animation("SetPortal")
		player.reset_velocities()


func PhysicsProcess(_delta):
	if diving:
		if timer_hit.time_left == 0.0 and timer_teleport.time_left <= 0.0 and timer_placing.time_left == 0.0:
			apply_gravity(1.25)
			player.set_side()
		if pre_timer_hit.time_left == 0.0:
			if len(player.obj_animations.get_check("HammerCollision").get_overlapping_bodies()) > 0:
				start_hit()
				print(player.obj_animations.get_check("HammerCollision").get_overlapping_bodies())

func pre_hit():
	pre_timer_hit.stop()

func get_hit(_a,_b):
	if is_current():
		if timer_placing.time_left > 0.0 or timer_teleport.time_left > 0.0:
			machine.change_state("Stun")

func start_hit():
	player.reset_velocities()
	diving = false
	timer_hit.start()
	player.obj_animations.play_animation("HammerHit")

func hit_player(_damage:int,_to:HurtBox):
	if is_current():
		start_hit()

func teleported():
	diving = true
	timer_teleport.stop()
	pre_timer_hit.start()

func quit_dive():
	timer_hit.stop()
	machine.change_state("Fall")

func portal_placed():
	machine.change_state("Idle")

func Exit(_new_state):
	timer_hit.stop()
	timer_placing.stop()
	timer_placing.stop()
