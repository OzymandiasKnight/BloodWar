extends PlayerState

@export var after_state:String = "Idle"
@export var duration:float = 0.5
##Negative = Ineffective, 0 = Instant Stop, Positive = Time for to fully stop
@export var deceleration_time:float = -1.0
@export var reset_gravity:bool = false
@export var gravity:bool = false
var timer:Timer = Timer.new()
var slow_timer := Timer.new()

var base_speed:float = 0.0

func Ready():
	super()
	timer.set_wait_time(duration)
	timer.connect("timeout",idle)
	add_child(timer)
	if deceleration_time > 0.0:
		slow_timer.set_wait_time(deceleration_time)
		slow_timer.timeout.connect(stopped)
		add_child(slow_timer)

func Enter(_old_state):
	if deceleration_time == 0.0:
		player.vel_mov.x = 0
	if deceleration_time > 0.0:
		slow_timer.start()
	base_speed = player.vel_mov.x
	timer.start()

func PhysicsProcess(_delta:float):
	if gravity:
		apply_gravity()
	if deceleration_time > 0.0:
		player.vel_mov.x = base_speed*(slow_timer.time_left/duration)

func stopped():
	slow_timer.stop()

func idle():
	timer.stop()
	machine.change_state(after_state)
	
func Exit(_new_state):
	timer.stop()
	if reset_gravity:
		player.vel_gra.y = 0.0
