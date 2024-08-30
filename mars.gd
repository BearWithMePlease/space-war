extends AnimatedSprite2D

var rotation_time = 30
var time = 15

var height = 370
var length = 550

var middle = Vector2(30,0)

@onready var path_line = $"../mars line"

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
	
	
	if time < rotation_time + 100: #prevention form overflow
		path_line.add_point(position)
	
	pass
