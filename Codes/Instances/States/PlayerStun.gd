extends PlayerState

@export var stun_time:float = 0.7

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
		if player.vel_kb.length() > 10:
			player.obj_animations.get_particle("Propulse").rotation = Vector2(0,0).angle_to_point(player.velocity)
			var propulsion_scale:float = player.velocity.length()/float(player.stat_speed)
			propulsion_scale = clamp(propulsion_scale,0.0,2.0)
			print(propulsion_scale)
			player.obj_animations.get_particle("Propulse").scale = Vector2(1,1)*(propulsion_scale/2.0)
			player.world.play_particle(player.obj_animations.get_particle("Propulse"))

func unstun():
	timer.stop()
	if previous_state.name in ["StraightPunch","WalkKick","DashSlash","HammerDive","Throw"]:
		machine.change_state("Idle")
	elif previous_state.name in ["Edge","DownPunch"]:
		machine.change_state("Fall")
	else:
		machine.change_state(previous_state.name)
	
func Exit(_new_state):
	timer.stop()
