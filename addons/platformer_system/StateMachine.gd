extends Node
class_name StateMachine

signal state_entered(new_state:State)

@export var master:Entity
@export var default_state:State
@export var auto_ready:bool = true

var current_state:State = null

var restricted_states:Array = []

func set_ready():
	for node in get_children():
		if node is State:
			node.machine = self
			node.master = master
			node.Ready()
	
	change_state(default_state.name)

func _ready():
	if auto_ready:
		set_ready()


func _process(delta):
	current_state.Process(delta)

func _physics_process(delta):
	current_state.PhysicsProcess(delta)

func change_state(new_state:String):
	if !(new_state in restricted_states):
		var old_state:State = current_state
		if current_state:
			current_state.Exit(new_state)
		current_state = get_node(new_state)
		current_state.Enter(old_state)
		emit_signal("state_entered",current_state)

func get_state(state_name:String):
	return get_node(state_name)
