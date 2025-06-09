extends Sprite2D
class_name SpriteParticle

@export var frame_time:float = 0.2
@export var particle_interval:float = 0.0
@export var random_rotation:bool = false
@export var min_size = -0.1



var timer := Timer.new()
var active:bool = false
var interval_timer := Timer.new()

func _ready():
	if active:
		timer.timeout.connect(end_particle)
		timer.set_wait_time(frame_time)
		add_child(timer)
		timer.start()
		if random_rotation:
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			
			rotation_degrees = rng.randf_range(-360.0,360.0)
			
			if min_size >= 0.0:
				rng.randomize()
				scale.x = rng.randf_range(min_size, scale.x)
				rng.randomize()
				scale.y = rng.randf_range(min_size, scale.y)
				
	else:
		if particle_interval != 0.0:
			interval_timer.timeout.connect(interval_out)
			interval_timer.set_wait_time(particle_interval)
			add_child(interval_timer)
		visible = false
	frame = 0

func activate():
	active = true

func end_particle():
	timer.stop()
	if frame >= hframes*vframes-1:
		queue_free()
	else:
		frame += 1
		timer.start()
	
func interval_out():
	interval_timer.stop()
