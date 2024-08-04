extends PlayerState

func Enter(_state):
	pass

func PhysicsProcess(_delta:float):
	if player.is_on_ground():
		player.vel_mov = Vector2(0,0)
		player.vel_gra = Vector2(0,0)
		
