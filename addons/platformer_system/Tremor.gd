extends Node2D
class_name TremorNode

##Maximum number of pixels moved
@export var strenght:float = 1.0
@export var speed:float = 1.0
@export var max_tremor:float = 1.0
@export var constant_tremor:float = 0.0

@export_category("Rotation Tremor")
@export var rotation_tremor:bool = false
@export var rotation_strenght:float = 1.0

var random:FastNoiseLite = FastNoiseLite.new()

var default_position := Vector2(0,0)

var time := 0.0

var tremor:float = 0.0


func _ready():
	default_position = position


func get_random() -> Vector3:
	return Vector3(random.get_noise_3d(time,0,0),random.get_noise_3d(0,time,0),random.get_noise_3d(0,0,time))

func _physics_process(delta):
	time += delta*speed
	position.x = default_position.x + get_random().x*(strenght*((tremor+constant_tremor)/max_tremor))
	position.y = default_position.y + get_random().y*(strenght*((tremor+constant_tremor)/max_tremor))
	
	if rotation_tremor:
		rotation_degrees = get_random().z*(strenght*((tremor+constant_tremor)/max_tremor))*rotation_strenght
	
	tremor = max(tremor-delta,0)
	


func add_tremor(value:float):
	tremor = min(max_tremor,tremor+value)
	
