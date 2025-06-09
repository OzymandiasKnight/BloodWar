extends Resource
class_name InputAction

##Input name in the Editor Settings
@export var input:String = ""
##"Id" in the InputBox used by functions : is_action(id)
@export var action:String = ""
##Max frames this key can attain when hold
@export var max_frames:int = 0

@export var joypad_trigger:bool = false

@export var instant_release:bool = true
