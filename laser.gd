extends Sprite2D

class_name Laser

"""
Code ist außer Kontrolle geraten...
1. Initialize Satellite
	is Player? => Wait for mouse press
	is Bot? => Wait initCooldownForBot and target botTarget
2. Make shot
	hit the planet? => Apply damage
	wait for shotCooldownBeforeHide after shot
3. Hide Satellite
"""

const MAX_LASER_DST := 3000.0 # for line2D
@export var orbitRadius: float = 130.0
@export var unActiveLaser: Texture2D = null
@export var activeLaser: Texture2D = null
@export var laserLine: Line2D = null
@export var botTarget: Node2D = null
@export var shotCooldownBeforeHide: float = 1.0
@export var initCooldownForBot: float = 2.5
@export var isPlayer := false
var coolDownTimer := 0.0
var initCoolDownTimer := 0.0
var isInitialized := false
var canApplyDamage := false
var targetDirection := Vector2(0, 0)

func _ready() -> void:
	isInitialized = false

func initialize() -> bool:
	if isInitialized:
		return false
	isInitialized = true
	coolDownTimer = 0.1 # just so it doesn't react to using slot
	initCoolDownTimer = initCooldownForBot
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var targetPos: Vector2 = Vector2(0, 0)
	if isPlayer:
		targetPos = get_global_mouse_position()
	else:
		targetPos = botTarget.global_position
		
	# Moving in circle around planet following mouse
	targetDirection = (targetPos - get_parent().global_position).normalized()
	self.position = targetDirection * orbitRadius;
	var angle := atan2(targetDirection.y, targetDirection.x) + PI * 0.5
	self.rotation = angle
	
	# Animation of laser & hiding satellite
	coolDownTimer = max(coolDownTimer - delta, 0.0)
	initCoolDownTimer = max(initCoolDownTimer - delta, 0.0)
	self.visible = coolDownTimer > 0.01 or isInitialized
	self.texture = activeLaser if coolDownTimer > shotCooldownBeforeHide - 0.1 else unActiveLaser
	
	if not isInitialized:
		var alpha: float = -(4.0 * (coolDownTimer - shotCooldownBeforeHide)) * (4.0 * (coolDownTimer - shotCooldownBeforeHide)) + 1.0
		laserLine.default_color = Color(172.0 / 255.0, 50.0 / 255.0, 50.0 / 255.0, alpha)
		return
		
	# Input for shot
	if coolDownTimer < 0.01:
		if !isPlayer and initCoolDownTimer < 0.01:
			shot(targetPos)
		elif isPlayer:
			const AIM_COLOR := Color("9badb7")
			laserLine.default_color = AIM_COLOR
			if Input.is_action_just_pressed("click"):
				shot(targetPos)



func shot(targetPos: Vector2) -> void:
	coolDownTimer = shotCooldownBeforeHide
	isInitialized = false
	canApplyDamage = true
	$"../../../AudioPlayer".play_sound(AudioPlayer.SoundType.LASER_LAUNCH_SOUND)


func _physics_process(delta):
	# Raycast planets
	if coolDownTimer > 0.01:
		var space_state = get_world_2d().direct_space_state
		var query = PhysicsRayQueryParameters2D.create(
			laserLine.global_position, 
			laserLine.global_position + targetDirection * MAX_LASER_DST
		)
		query.collide_with_areas = true
		
		var result = space_state.intersect_ray(query) 
		if result:
			laserLine.points[0] = laserLine.position
			const I_DONT_KNOW_WHY := 1.65
			var dst: float = (result.position - laserLine.global_position).length()
			laserLine.points[1] = laserLine.position + Vector2(0, -dst * I_DONT_KNOW_WHY)
			var hitPlanet := result.collider.get_parent() as Planet
			var hitShield := result.collider.get_parent().get_parent() as Shield
			if canApplyDamage:
				canApplyDamage = false
				if hitPlanet != null:
					print("reached the planet")
					for child in hitPlanet.get_children():
						if child is Population:
							child.take_hit(1000000000)
							break
				if hitShield != null:
					print("reached the shield")
					hitShield.removeShield()
				
		else:
			laserLine.points[0] = laserLine.position
			laserLine.points[1] = laserLine.position + Vector2(0, -MAX_LASER_DST)
