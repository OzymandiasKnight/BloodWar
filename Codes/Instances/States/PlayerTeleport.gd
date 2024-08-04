extends  PlayerState

@export var teleport_distance:float = 100

@export var activation_time:float = 0.2

var timer_activation:Timer = Timer.new()

var teleporting:bool = false

func Ready():
	super()
	timer_activation.set_wait_time(activation_time)
	timer_activation.connect("timeout",teleport)
	add_child(timer_activation)
	player.get_hit.connect(get_hit)

func Enter(_old_state):
	player.vel_gra.y = 0
	player.vel_mov.x = 0
	player.set_side()
	teleporting = true
	timer_activation.start()

func Exit(_new_state):
	teleporting = false
	timer_activation.stop()

func get_hit():
	if teleporting:
		machine.change_state("Stun")

func teleport():
	timer_activation.stop()
	player.set_side()
	if player.side == 0:
		player.vel_gra.y = 0
		player.vel_tp.y = -teleport_distance*50
	else:
		player.vel_tp.x = player.side_last*teleport_distance*50
	machine.change_state("Fall")
