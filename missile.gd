extends AnimatedSprite2D

@export var speed: float = 100.0

var target_angle = 0
var time = 0
var target: Node2D
var launcher: Node2D
var target_vector: Vector2 = Vector2(0, 0)

func sendRocket(target: Node2D, launcher: Node2D) -> void:
	self.target = target
	self.launcher = launcher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	scale = Vector2(0.1*time, 0.1*time)
	global_position = launcher.global_position
	target_vector = Vector2(position.x - target.position.x, position.y- target.position.y)
	print(rad_to_deg(target_vector.angle()))
	self.rotation = target_vector.angle() - 0.5 * PI
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time += delta
	if time < 0.3:
		speed = 1300*time + 300
		scale = Vector2(0.0 + 1.5*time, 0.0 + 1.5*time)
	else:
		target_vector = Vector2(position.x - target.position.x, position.y- target.position.y)
		target_angle = target_vector.angle()
		self.rotation = target_angle - 0.5 * PI

	if target_vector.length() < 30:
		queue_free()

	move_local_y(-speed*delta)
