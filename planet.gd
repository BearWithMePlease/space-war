extends AnimatedSprite2D

class_name Planet

@export var rotation_time = 10
@export var start_time = 0
@export var height = 250
@export var length = 300
@export var middle = Vector2(0,0)
@export var path_line: Line2D
var time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	time = start_time
	play()
	if path_line != null:
		path_line.clear_points() 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	position.x = length * cos((2 * PI * time) / rotation_time) + middle.x
	position.y = height * sin((2 * PI * time) / rotation_time) + middle.y
	if time < rotation_time + 10 and path_line != null: #prevention form overflow
		path_line.add_point(position)
