extends Resource
class_name InputPack

@export var inputs:Array[InputAction]

func action_to_input(action_name:String) -> Array[String]:
	var list:Array[String] = []
	for action in inputs:
		if action.action == action_name:
			list.append(action.action)
	return list
