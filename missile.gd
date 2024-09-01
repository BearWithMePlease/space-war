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

var hit:bool = false

func sendRocket(target: Node2D, launcher: Node2D) -> void:
	self.target = target
	self.launcher = launcher

# Called when the node enters the scene tree for the first time.
func _ready() -> void:	
	scale = Vector2(0.1*time, 0.1*time)
	global_position = launcher.global_position
	target_vector = Vector2(position.x - target.position.x, position.y- target.position.y)
	#print(rad_to_deg(target_vector.angle()))
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
		
		if !hit:
			self.rotation = target_angle - 0.5 * PI


	
	if !hit:
		if target_vector.length() < 30:
			if launcher.object_struck_shield1:
				target.find_child("Shield").removeShield()
				launcher.object_struck_shield1 = false
				detonate(target)
			elif launcher.object_struck_shield2:
				target.find_child("Shield").removeShield()
				launcher.object_struck_shield2 = false
				detonate(target)
			else:
				var population_child = target.find_child("Population")
				if population_child != null:
					target.find_child("Population").take_hit(900000)
					detonate(target)
		
		collision_detection()
		
		move_local_y(-speed*delta)


#static var venus_hit:bool = false
#static var mercury_hit:bool = false

var explosion = preload("res://explosion.tscn")

func detonate(strike):
	hit = true
	var new_explosion = explosion.instantiate()
	new_explosion.attackVector = self.global_position-strike.global_position
	new_explosion.mercury = mercury
	new_explosion.venus = venus	
	strike.add_child(new_explosion)
	queue_free()

func collision_detection():
	if sun != null:
		sun_vector = Vector2(position.x - sun.position.x, position.y - sun.position.y)
		if sun_vector.length() < 50:
			print("hit the sun")
			detonate(sun)
	
	if venus != null and !venus.isHit:
		venus_vector = Vector2(position.x - venus.position.x, position.y - venus.position.y)
		if venus_vector.length() < 30:
			print("hit the venus")
			venus.isHit = true
			detonate(venus)
		
	if mercury != null and !mercury.isHit:
		mercury_vector = Vector2(position.x -mercury.position.x, position.y - mercury.position.y)
		if mercury_vector.length() < 30:
			print("hit the mercury")
			mercury.isHit = true
			detonate(mercury)
	
	

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
