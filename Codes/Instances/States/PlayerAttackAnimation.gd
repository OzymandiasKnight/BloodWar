extends PlayerState

@export var after_state:String = "Idle"
@export var duration:float = 0.5
@export var raw_stop:bool = false
@export var slow_speed:bool = false
@export var gravity:bool = false
var timer:Timer = Timer.new()

var base_speed:float = 0.0

func Ready():
	super()
	timer.set_wait_time(duration)
	timer.connect("timeout",idle)
	add_child(timer)

func Enter(_old_state):
	if raw_stop:
		player.vel_mov.x = 0
	base_speed = player.vel_mov.x
	timer.start()

func PhysicsProcess(delta:float):
	if gravity:
		apply_gravity()
	if slow_speed:
		player.vel_mov.x = base_speed*(timer.time_left/duration)

func idle():
	timer.stop()
	machine.change_state(after_state)
	
func Exit(_new_state):
	timer.stop()
