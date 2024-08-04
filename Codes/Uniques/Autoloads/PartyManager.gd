extends Node

var controller_packs:Dictionary = {}

var match_data:Dictionary = {
	"players": {
		
	},
	"stats": {
		
	},
	"modifiers": {
		
	}
}

var default_controller_pack:InputPack = preload("res://Ressources/Instances/InputPacks/ControllerInputPack.tres")


func _ready():
	controller_packs[0] = default_controller_pack
	
	for id in range(1,4):
		print(id)
		var new_pack := InputPack.new()
		var new_inputs:Array[InputAction] = []
		for key in get_controller_pack(0).inputs:
			var new_action := InputAction.new()
			new_action.action = key.action
			new_action.input = key.input.left(-1)+str(id+1)
			new_inputs.append(new_action)
		new_pack.inputs = new_inputs
		controller_packs[id] = new_pack
	
	duplicate_controller_maps()


func duplicate_controller_maps():
	var controller_actions:Array[String] = ["leftc","rightc","upc","attackc","parryc","specialc"]
	
	for device_id in range(3):
		device_id += 2
		for action in controller_actions:
			var new_action:String = action+str(device_id)
			InputMap.add_action(new_action)
			
			var event:Array[InputEvent] = InputMap.action_get_events(action+"1")
			var new_events:Array[InputEvent]
			for key in event:
				if key is InputEventJoypadMotion:
					var input_event := InputEventJoypadMotion.new()
					input_event = key.duplicate()
					input_event.device = device_id-1
					new_events.append(input_event)
				if key is InputEventJoypadButton:
					var input_event :=InputEventJoypadButton.new()
					input_event = key.duplicate()
					input_event.device = device_id-1
					new_events.append(input_event)
					
			for input in new_events:
				InputMap.action_add_event(new_action,input)

func add_stat(id:int,stat_name:String,value:int):
	print(match_data["stats"])
	if match_data["stats"][id].has(stat_name):
		match_data["stats"][id][stat_name] += value
	else:
		match_data["stats"][id][stat_name] = value

func get_color(skin:String,id:int) -> Color:
	if skin == "Fire":
		return [Color("ed7b39"),Color("bd4035"),Color("ffb84a")][id]
	elif skin == "Thunder":
		return [Color("f8ffb8"),Color("f0c297"),Color("faffff")][id]
	elif skin == "Poison":
		return [Color("77b02a"),Color("429058"),Color("c6d831")][id]
	elif skin == "Dimension":
		return [Color("1a466b"),Color("132243"),Color("10908e")][id]
	elif skin == "Void":
		return [Color("94007a"),Color("35003b"),Color("d61a88")][id]
	elif skin == "Ink":
		return [Color("392946"),Color("24142c"),Color("5b537d")][id]
	elif skin == "Ice":
		return [Color("78d7ff"),Color("488bd4"),Color("b0fff1")][id]
	else:
		#Blood Default Color
		return [Color("d41e3c"),Color("9b0e3e"),Color("ed4c40")][id]

func get_controller_pack(device_id:int) -> InputPack:
	return controller_packs[device_id]
