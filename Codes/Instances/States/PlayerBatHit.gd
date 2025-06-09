extends PlayerState


@export var hit_time:float = 0.5

var timer:Timer = Timer.new()

func Ready():
	super()
	timer.timeout.connect(has_hit)
	timer.wait_time = hit_time
	add_child(timer)

func Enter(_old_state):
	player.set_side()
	player.vel_gra.y = -player.stat_jump*1.25
	player.vel_mov.x += player.side_last*250
	timer.start()

func PhysicsProcess(_delta):
	apply_gravity()

func has_hit():
	timer.stop()
	machine.change_state("Fall")
