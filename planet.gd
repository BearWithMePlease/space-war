extends AnimatedSprite2D

class_name Planet

@export var rotation_time: float = 10.0
@export var start_time: float = 0.0
@export var height: float = 250.0
@export var length: float = 300.0
@export var middle = Vector2(0,0)
@export var path_line: Line2D = null
var time = 0

@export var isHit = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = start_time
	play()
	generatePathLine()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	position.x = length * cos((2 * PI * time) / rotation_time) + middle.x
	position.y = height * sin((2 * PI * time) / rotation_time) + middle.y

func generatePathLine() -> void:
	if path_line != null:
		path_line.clear_points()
		var simulationTime := 100.0
		const SIMULATION_STEPS := 100
		const SIMULATION_TIMESTEP := 0.016
		for i in range(SIMULATION_STEPS):
			path_line.add_point(Vector2(
				length * cos((2.0 * PI * simulationTime)) + middle.x,
				height * sin((2.0 * PI * simulationTime)) + middle.y
			))
			simulationTime += SIMULATION_TIMESTEP
