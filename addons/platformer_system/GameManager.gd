extends CanvasLayer

@onready var obj_transitions:AnimationPlayer = get_node("Transitions")

@export var scenes:Array[SceneKey]

var current_scene:SceneKey

func _ready():
	obj_transitions.animation_finished.connect(transition_finished)

func _input(event):
	if event.is_pressed():
		if event is InputEventKey:
			if event.keycode == KEY_F11:
				if event.echo == false:
					if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
					else:
						DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func change_scene(scene_name:String):
	for key in scenes:
		if key.scene == scene_name:
			current_scene = key
			if current_scene.in_animation != "":
				obj_transitions.play(current_scene.in_animation)
			else:
				load_current_scene()
			break

func load_current_scene():
	if current_scene:
		get_tree().change_scene_to_packed(current_scene.path)

func transition_finished(animation_name:String):
	if current_scene:
		if current_scene.in_animation == animation_name:
			load_current_scene()
			obj_transitions.play(current_scene.out_animation)

func save_file(path:String,value:Variant):
	var file = FileAccess.open(path,FileAccess.WRITE)
	file.store_var(value)
	file.close()

func load_file(path:String,default_value:Variant) -> Variant:
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path,FileAccess.READ)
		var content = file.get_var()
		file.close()
		if typeof(content) == typeof(default_value):
			return content
		else:
			return null
	else:
		save_file(path,default_value)
		return default_value

