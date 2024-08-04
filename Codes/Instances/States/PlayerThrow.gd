extends PlayerState

@export var throw_time:float = 0.2

var timer:Timer = Timer.new()


func Ready():
	super()
	timer.set_wait_time(throw_time)
	timer.connect("timeout",throw)
	add_child(timer)

func Enter(_old_state):
	timer.stop()
	timer.start()

func throw():
	timer.stop()
	machine.change_state("Walk")
	
func Exit(_new_state):
	timer.stop()
