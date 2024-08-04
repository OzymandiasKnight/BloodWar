extends Node
class_name InputBox

signal action_just_pressed(action_name:String)
signal action_just_released(action_name:String)
signal action_frames_maxed(action_name:String)

@export var input_pack:InputPack

var inputs = {}

func _ready():
	pass

func _physics_process(delta):
	if input_pack:
		for key in input_pack.inputs:
			if Input.is_action_pressed(key.input):
				if inputs.has(key.action):
					if key.max_frames != 0:
						inputs[key.action] = min(key.max_frames,inputs[key.action]+1)
						if inputs[key.action] == key.max_frames:
							action_frames_maxed.emit(key.action)
					else:
						inputs[key.action] += 1
				else:
					inputs[key.action] = 1
					action_just_pressed.emit(key.action)
			else:
				if inputs.has(key.action):
					action_just_released.emit(key.action)
					if key.instant_release:
						inputs.erase(key.action)
					else:
						inputs[key.action] = max(0,inputs[key.action]-1)
						if inputs[key.action] == 0:
							inputs.erase(key.action)

func is_any_action_pressed():
	return len(inputs.keys()) > 0

func is_action_pressed(action_name:String) -> bool:
	return inputs.has(action_name)

func is_action_just_pressed(action_name:String) -> bool:
	if inputs.has(action_name):
		return inputs[action_name]==1
	else:
		return false

func get_action_frames(action_name:String) -> int:
	if inputs.has(action_name):
		return inputs[action_name]
	else:
		return 0
