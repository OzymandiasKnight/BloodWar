extends PlayerState

func Enter(_state):
	pass


func PhysicsProcess(_delta:float):
	if player.is_on_ground():
		player.reset_velocities()
	else:
		apply_gravity()

func Exit(_new_state):
	player.hurtbox.get_node("Collision").set_deferred("disabled",true)
