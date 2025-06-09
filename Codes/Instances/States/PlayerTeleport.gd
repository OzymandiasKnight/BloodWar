extends  PlayerState

@export var teleport_distance:float = 100

@export var activation_time:float = 0.2

var timer_activation:Timer = Timer.new()

var teleporting:bool = false

var base_speed:float = 0

var falling_previous:PlayerState

func Ready():
	super()
	timer_activation.set_wait_time(activation_time)
	timer_activation.connect("timeout",teleport)
	add_child(timer_activation)
	player.get_hit.connect(get_hit)

func Enter(old_state):
	player.vel_gra.y = 0
	if old_state.name == "Fall":
		falling_previous = old_state.previous_state
		base_speed = player.vel_mov.x
	player.vel_mov.x = 0
	player.set_side()
	teleporting = true
	timer_activation.start()

func Exit(_new_state):
	teleporting = false
	timer_activation.stop()


func get_hit(_a,_b):
	if is_current():
		machine.change_state("Stun")

func teleport():
	timer_activation.stop()
	player.set_side()
	if player.side == 0:
		player.vel_gra.y = 0
		player.vel_tp.y = -teleport_distance
	else:
		player.vel_tp.x = teleport_distance*player.side_last

	if falling_previous.name != "Teleport":
		player.vel_mov.x = abs(base_speed)*player.side_last
	else:
		player.vel_kb = Vector2(0,0)
	machine.change_state("Fall")
