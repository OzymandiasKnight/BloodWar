extends PlayerState

@export var ready_time:float = 1.5

var timer:Timer = Timer.new()


func Ready():
	super()
	timer.set_wait_time(ready_time)
	timer.connect("timeout",set_ready)
	add_child(timer)

func Enter(_old_state):
	timer.start()

func PhysicsProcess(_delta):
	apply_gravity()

func set_ready():
	machine.change_state("Idle")

func Exit(_new_state):
	timer.stop()
	player.vel_gra.y = 0
