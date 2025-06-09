extends PlayerState

var previous_state:PlayerState = null

func Enter(old_state):

	previous_state = old_state
	if previous_state.name == "Edge":
		player.set_side()
		player.vel_gra.y = -player.stat_jump*1.2
		player.vel_mov.x = (abs(player.vel_mov.x)+50)*player.side_last

	else:
		player.vel_gra.y = -player.stat_jump
