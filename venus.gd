extends AnimatedSprite2D

var rotation_time = 12
var time = 10

var height = 150
var length = 210

var middle = Vector2(0,10)

@onready var path_line = $"../venus line"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	#if time > rotation_time*2:
		#time = 0
	

	position.x = length * cos((2 * PI * time) / rotation_time) + middle.x
	position.y = height * sin((2 * PI * time) / rotation_time) + middle.y
	
	
	if time < rotation_time + 30: #prevention form overflow
		path_line.add_point(position)
	pass
