extends PlayerState

@export var offset:Vector2 = Vector2(12,24)

func Ready():
	super()
	player.get_hit.connect(get_hit)


func Enter(_state):
	player.reset_velocities()
	player.global_position = player.is_on_edge()+Vector2(-offset.x*player.side_last,offset.y)
	player.che_edge.enabled = false

func PhysicsProcess(_delta:float):
	if player.input_box.is_action_just_pressed("jump"):
		machine.change_state("Jump")

func Exit(_new_state):
	player.che_edge.enabled = true
	player.che_edge.force_raycast_update()

func get_hit():
	if is_current():
		machine.change_state("Stun")
