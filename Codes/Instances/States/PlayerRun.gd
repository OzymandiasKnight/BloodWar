extends PlayerState

@export var use_cost:int = 10

var speed:int = 50

func Enter(old_state:State):
	speed = player.stat_speed
	if old_state.name == "Fall":
		var entry_level = player.stat_weight+player.stat_jump
		if player.vel_gra.y > entry_level:
			player.vel_mov.x = player.side_last*(speed+min(player.vel_gra.y-entry_level,speed))
		player.vel_gra.y = 0
	else:
		player.vel_mov.x = player.side_last*speed

func PhysicsProcess(_delta:float):
	player.set_side()
	if player.side == 0:
		machine.change_state("Idle")
	elif not player.input_box.is_action_pressed("shift"):
		machine.change_state("Walk")
	else:
		if player.input_box.is_action_just_pressed("attack"):
			if player.input_box.is_action_pressed("parry"):
				if player.use_health(use_cost):
					machine.change_state("DashSlash")
			else:
				machine.change_state("StraightPunch")
		else:
			player.vel_mov.x = lerp(abs(player.vel_mov.x),float(speed),0.1)*player.side_last
