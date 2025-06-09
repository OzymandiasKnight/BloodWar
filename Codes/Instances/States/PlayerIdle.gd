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
			if player.input_box.is_action_just_pressed("attack"):
				if player.input_box.is_action_pressed("parry"):
					if player.use_health(20):
						machine.change_state("HammerDive")
			else:
				if abs(player.vel_kb.x) > 0.0:
					var rock_size:float = player.vel_kb.x/(player.stat_speed/2.0)
					rock_size = clamp(rock_size,0.75,1.75)
					player.obj_animations.get_particle("GroundSlide").scale.x = rock_size*player.side_last
					player.obj_animations.play_sprite_particle("GroundSlide")
					if sign(player.vel_kb.x) != sign(player.side_last):
						player.obj_animations.play_animation("IdleKb")
					else:
						player.obj_animations.play_animation("Idle")
				else:
					player.obj_animations.play_animation("Idle")
			player.vel_mov.x = lerp(player.vel_mov.x,0.0,0.1)
