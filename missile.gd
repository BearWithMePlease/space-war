extends AnimatedSprite2D

@export var speed: float = 100.0

var target_angle = 0
var time = 0
var target: Node2D
var launcher: Node2D
var target_vector: Vector2 = Vector2(0, 0)
var sun_vector: Vector2
var venus_vector: Vector2
var mercury_vector: Vector2

var sun = null
var venus = null
var mercury = null

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
		target_vector = Vector2(position.x - target.position.x, position.y - target.position.y)
		target_angle = target_vector.angle()
		self.rotation = target_angle - 0.5 * PI


	
	
	if target_vector.length() < 30:
		queue_free()
		
	
	collision_detection()
	
	move_local_y(-speed*delta)


func collision_detection():
	sun_vector = Vector2(position.x - sun.position.x, position.y - sun.position.y)
	if sun_vector.length() < 30:
		print("hit the sun")
		queue_free()
	venus_vector = Vector2(position.x - venus.position.x, position.y - venus.position.y)
	if venus_vector.length() < 30:
		print("hit the venus")
		queue_free()
		
	mercury_vector = Vector2(position.x -mercury.position.x, position.y - mercury.position.y)
	if mercury_vector.length() < 30:
		print("hit the mercury")
		queue_free()
	
	

#func _on_missile_area_entered(hit: Area2D) -> void:
	
	#
	#
	#
	#if hit.get_parent() == launcher.get_parent() or target == hit.get_parent() or hit.get_parent() == self: # friendly fire prevention, if disabled explodes on launch
		#print("nothing happens")
	#else:
		#
		#print(hit.get_parent())
		##hit.get_parent().death()
		#
	#
#
		#
		#print("clearing")
		#queue_free()
