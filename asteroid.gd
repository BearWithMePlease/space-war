extends Sprite2D

class_name Asteroid

@export var speed := 200.0
var launcher: Node2D = null
var target: Node2D = null
var time: float = 0
var castTime := 0.0
var directionSet: bool = false

func initialize(launcher: Node2D, target: Node2D, texture: Texture2D) -> void:
	self.launcher = launcher
	self.target = target
	self.texture = texture
	castTime = 0.5

func _ready() -> void:
	global_position = launcher.global_position

func _process(delta: float) -> void:
	if not directionSet:
		global_position = launcher.global_position
		
	castTime = max(0.0, castTime - delta)
	if(castTime > 0.01):
		return
		
	if Input.is_action_just_pressed("click") and !directionSet:
		var mouse_position = get_global_mouse_position()
		var direction = mouse_position - global_position
		rotation = direction.angle()
		directionSet = true
	
	if not directionSet:
		return
		
	time += delta
	move_local_x(speed * delta)
	
	if time > 30.0:
		queue_free()
	
	var target_vector := Vector2(position.x - target.position.x, position.y - target.position.y)
	if target_vector.length() < 45.0:
		queue_free()
