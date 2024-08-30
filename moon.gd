extends AnimatedSprite2D

var rotation_time = 2
var time = 0

var height = 100
var length = 100

var middle = Vector2(0,0)

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
	
	

	pass
