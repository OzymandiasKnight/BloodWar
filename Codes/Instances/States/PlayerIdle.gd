extends PlayerState

func Enter(_state):
	player.vel_gra.y = 0

func PhysicsProcess(_delta:float):
	player.set_side()
	if player.side != 0:
		if player.input_box.is_action_pressed("shift"):
			machine.change_state("Run")
		else:
			machine.change_state("Walk")
	else:
		if player.input_box.is_action_just_pressed("parry"):
			machine.change_state("Parry")
		else:
			player.vel_mov.x = lerp(player.vel_mov.x,0.0,0.1)
