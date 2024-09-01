extends AnimatedSprite2D

var target: Node2D
var launcher: Node2D
var length = -60

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var attackVector = launcher.global_position-target.global_position
	var angle = attackVector.angle()
	rotation = angle -  deg_to_rad(90)
	if target == $Planets/mars:
		length = -54
	position = Vector2(cos(angle), sin(angle)) * length
	play()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func death():
	queue_free()

func _on_animation_looped() -> void:
	death()
	pass # Replace with function body.
