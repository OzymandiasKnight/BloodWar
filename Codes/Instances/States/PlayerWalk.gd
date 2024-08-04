extends PlayerState

@export var walk_speed:int = 5
@export var use_cost:int = 10

func Enter(_old_state:State):
	player.vel_mov.x = player.side_last*walk_speed

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
