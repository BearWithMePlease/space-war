extends AnimatedSprite2D

var rotation_time = 10
var time = 0

var height = 250
var length = 300

var middle = Vector2(0,0)

# Reference to the Line2D node
@onready var path_line = $"../Line2D"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	path_line.clear_points() 
	#rotate(deg_to_rad(180))
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	#if time > rotation_time*2:
		#time = 0
	

	position.x = length * cos((2 * PI * time) / rotation_time) + middle.x
	position.y = height * sin((2 * PI * time) / rotation_time) + middle.y
	
	
	if time < rotation_time + 10: #prevention form overflow
		path_line.add_point(position)
