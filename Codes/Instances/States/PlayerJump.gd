extends PlayerState

var previous_state:PlayerState = null

func Enter(old_state):
	previous_state = old_state
	if previous_state.name == "Edge":
		player.vel_gra.y = -player.stat_jump*1.1
	else:
		player.vel_gra.y = -player.stat_jump
	if old_state.name == "Edge":
		player.vel_mov.x = player.side_last*50
