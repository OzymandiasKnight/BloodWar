extends PlayerState

@export var stun_time:float = 0.1

var timer:Timer = Timer.new()

var previous_state:PlayerState = null

func Ready():
	super()
	timer.set_wait_time(stun_time)
	timer.connect("timeout",unstun)
	add_child(timer)

func Enter(old_state):
	player.vel_gra = Vector2(0,0)
	player.vel_mov = Vector2(0,0)
	previous_state = old_state
	timer.stop()
	timer.start()

func PhysicsProcess(_delta):
	if player.is_on_ground():
		player.obj_animations.play_animation("StunGround")
	else:
		apply_gravity()

func unstun():
	timer.stop()
	if previous_state.name in ["StraightPunch","WalkKick","DashSlash"]:
		machine.change_state("Idle")
	elif previous_state.name in ["Edge","DownPunch"]:
		machine.change_state("Fall")
	else:
		machine.change_state(previous_state.name)
	
func Exit(_new_state):
	timer.stop()
