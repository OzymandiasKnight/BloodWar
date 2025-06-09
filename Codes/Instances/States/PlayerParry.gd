extends PlayerState

@export var animation_time:float = 0.5
@export var i_frames:float = 0.3

var timer:Timer = Timer.new()


func Ready():
	super()
	timer.set_wait_time(animation_time)
	timer.connect("timeout",unparry)
	add_child(timer)
	timer.stop()
	player.blocked_hit.connect(parried)
	player.get_hit.connect(got_hit)

func parried(_a,_b):
	if is_current():
		unparry()

func got_hit(_a,_b):
	if is_current():
		unparry()

func Enter(_old_state):
	timer.stop()
	timer.start()
	player.hurtbox.health_component.add_effect("invincibility",i_frames)

func unparry():
	timer.stop()
	machine.change_state("Idle")
	
func Exit(_new_state):
	timer.stop()
