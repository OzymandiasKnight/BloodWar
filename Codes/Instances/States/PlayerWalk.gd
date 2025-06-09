extends PlayerState

@export var use_cost:int = 10

var speed:int = 50

func Enter(_old_state:State):
	speed = int(float(player.stat_speed)/3)
	
	player.vel_mov.x = player.side_last*speed

func PhysicsProcess(_delta:float):
	player.set_side()
	if player.side == 0:
		machine.change_state("Idle")
	else:
		if player.input_box.is_action_pressed("shift"):
			machine.change_state("Run")
		else:
			if player.input_box.is_action_just_pressed("attack"):
				if player.input_box.is_action_pressed("parry") :
					if player.use_health(use_cost):
						machine.change_state("Throw")
				else:
					machine.change_state("WalkKick")
