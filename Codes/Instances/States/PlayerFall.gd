extends PlayerState

@export var use_cost:int = 10

@export var grace_time:float = 0.1

var timer := Timer.new()

var graced:bool = false

var previous_state:State

func Ready():
	super()
	timer.set_wait_time(grace_time)
	timer.connect("timeout",grace_out)
	add_child(timer)

func Enter(state):
	previous_state = state
	if state.name == "Teleport":
		set_graced()

func set_graced():
	timer.stop()
	timer.start()
	graced = true

func PhysicsProcess(_delta:float):
	
	if player.is_on_ground():
		if player.side != 0:
			if player.input_box.is_action_pressed("shift"):
				machine.change_state("Run")
			else:
				machine.change_state("Walk")
		else:
			machine.change_state("Idle")
	else:
		if player.input_box.is_action_just_pressed("attack"):
			if player.input_box.is_action_pressed("parry"):
				if player.use_health(use_cost):
					machine.change_state("Teleport")
			else:
				if previous_state.name != "DownPunch":
					machine.change_state("DownPunch")
		else:
			player.set_side()
			if not graced:
				apply_gravity()
				if player.vel_gra.y > 0:
					player.obj_animations.play_animation("Fall")
					if player.is_on_edge() != Vector2(0,0):
						machine.change_state("Edge")

func Exit(_state):
	ungrace()

func grace_out():
	ungrace()

func ungrace():
	timer.stop()
	graced = false
