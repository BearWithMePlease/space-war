extends Sprite2D

class_name Asteroid

@export var speed := 200.0
var launcher: Node2D = null
var target: Node2D = null
var time: float = 0
var castTime := 0.0
var directionSet: bool = false

var isPlayer: bool = false

var sun = null
var venus = null
var mercury = null

var sun_vector: Vector2
var venus_vector: Vector2
var mercury_vector: Vector2

func initialize(launcher: Node2D, target: Node2D, texture: Texture2D) -> void:
	self.launcher = launcher
	self.target = target
	self.texture = texture
	castTime = 0.1

func _ready() -> void:
	global_position = launcher.global_position

func _process(delta: float) -> void:
	
	if isPlayer:
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
	else:
		if !directionSet:
			var direction = target.global_position - global_position
			rotation = direction.angle() + deg_to_rad(15)
			directionSet = true
			
	time += delta
	move_local_x(speed * delta)
	
	if time > 30.0:
		queue_free()
	
	var target_vector := Vector2(position.x - target.position.x, position.y - target.position.y)
	
	
	if target_vector.length() < 45.0:
		var shield = target.find_child("Shield")
			
		if shield.shieldCount > 0:
			shield.removeShield()
			detonate(target)
			#queue_free()
		#if launcher.object_struck_shield1:
			#target.find_child("Shield").removeShield()
			#target.find_child("Missile Launcher").object_struck_shield1 = false
			#detonate(target)
		#elif launcher.object_struck_shield2:
			#target.find_child("Shield").removeShield()
			#target.find_child("Missile Launcher").object_struck_shield2 = false
			#detonate(target)
			
		else:
			var population = target.find_child("Population")
			if population != null:
				target.find_child("Population").take_hit(100000)
				detonate(target)

	
	collision_detection()

var explosion = preload("res://explosion.tscn")
var hit:bool = false

func detonate(strike):
	hit = true
	var new_explosion = explosion.instantiate()
	new_explosion.attackVector = self.global_position-strike.global_position
	new_explosion.mercury = mercury
	new_explosion.venus = venus	
	strike.add_child(new_explosion)
	queue_free()

func collision_detection():
	sun_vector = Vector2(position.x - sun.position.x, position.y - sun.position.y)
	if sun_vector.length() < 50:
		print("hit the sun")
		detonate(sun)
	
	if !venus.isHit:
		venus_vector = Vector2(position.x - venus.position.x, position.y - venus.position.y)
		if venus_vector.length() < 30:
			print("hit the venus")
			venus.isHit = true
			detonate(venus)
		
	if !mercury.isHit:
		mercury_vector = Vector2(position.x -mercury.position.x, position.y - mercury.position.y)
		if mercury_vector.length() < 30:
			print("hit the mercury")
			mercury.isHit = true
			detonate(mercury)
