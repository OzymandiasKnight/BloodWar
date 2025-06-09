extends Node

var controller_packs:Dictionary = {}

var match_data:Dictionary = {
	"players": {
		
	},
	"stats": {
		
	},
	"modifiers": {
		"max_rounds": 7,
		"hitbox_debug": false,
	}
}

var default_controller_pack:InputPack = preload("res://Ressources/Instances/InputPacks/ControllerInputPack.tres")

var freeze_timer := Timer.new()

var paused:bool = false

func _ready():
	
	freeze_timer.process_mode = Node.PROCESS_MODE_ALWAYS
	freeze_timer.wait_time = 0.1
	freeze_timer.timeout.connect(unfreeze)
	add_child(freeze_timer)
	
	controller_packs[0] = default_controller_pack
	
	for id in range(1,4):
		var new_pack := InputPack.new()
		var new_inputs:Array[InputAction] = []
		for key in get_controller_pack(0).inputs:
			var new_action := InputAction.new()
			new_action.action = key.action
			new_action.input = key.input.left(-1)+str(id+1)
			new_inputs.append(new_action)
		new_pack.inputs = new_inputs
		controller_packs[id] = new_pack
		add_SDL2_mapping(id-1)
		

	
	duplicate_controller_maps()

func add_SDL2_mapping(id):
	var joy_name:String = Input.get_joy_name(id)
	var joy_guid:String = Input.get_joy_guid(id)
	var mapping:String = 'Afterglow PS3 Controller,a:b1,b:b2,y:b3,x:b0,start:b9,guide:b12,back:b8,dpup:h0.1,dpleft:h0.8,dpdown:h0.4,dpright:h0.2,leftshoulder:b4,rightshoulder:b5,leftstick:b10,rightstick:b11,leftx:a0,lefty:a1,rightx:a2,righty:a3,lefttrigger:b6,righttrigger:b7'
	var final_mapping:String = '%s, %s, %s' % [joy_guid, joy_name, mapping] 
	Input.add_joy_mapping(final_mapping, true)

func duplicate_controller_maps():
	var controller_actions:Array[String] = ["leftc","rightc","upc","attackc","parryc","lightc"]
	
	for device_id in range(3):
		device_id += 2
		for action in controller_actions:
			var new_action:String = action+str(device_id)
			InputMap.add_action(new_action)
			
			var event:Array[InputEvent] = InputMap.action_get_events(action+"1")
			var new_events:Array[InputEvent] = []
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
	if match_data["stats"].has(id):
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
	elif skin == "Cloud":
		return [Color("c7d4e1"),Color("928fb8"),Color("faffff")][id]
	else:
		#Blood Default Color
		return [Color("d41e3c"),Color("9b0e3e"),Color("ed4c40")][id]

func get_controller_pack(device_id:int) -> InputPack:
	return controller_packs[device_id]

func pause(is_paused:bool):
	paused = is_paused
	freeze_timer.paused = is_paused
	if not is_paused:
		if freeze_timer.time_left <= 0.0:
			get_tree().paused = is_paused
	else:
		get_tree().paused = is_paused

func freeze(time:float=0.1):
	freeze_timer.stop()
	freeze_timer.wait_time = time
	freeze_timer.start()
	get_tree().paused = true

func unfreeze():
	get_tree().paused = paused
	freeze_timer.stop()
