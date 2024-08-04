extends Node
class_name State

var machine:StateMachine = null
var master:CharacterBody2D = null

func Ready():
	pass

func Enter(old_state:State):
	pass

func Process(delta:float):
	pass

func PhysicsProcess(delta:float):
	pass

func Exit(new_state:String):
	pass

func is_current() -> bool:
	return machine.current_state == self
