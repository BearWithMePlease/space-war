extends Sprite2D

@export var radius: float = 130
@export var unActiveLaser: Texture2D
@export var activeLaser: Texture2D
@export var laserLine: Line2D = null
@export var shotCooldown: float = 1.0

const MAX_LASER_DST := 3000.0
var needsToShot: bool = false
var coolDownTimer: float = 0.0
var bought: bool = false

var isPlayer = true
var target
func addLaserSatelite(target1, player: bool) -> bool:
	if bought:
		return false
	bought = true
	coolDownTimer = 0.05 # don't shot immediately after bought
	isPlayer = player
	target = target1
	return true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:

	if !bought and coolDownTimer < 0.01:
		self.visible = false
		return
	self.visible = true
	
	# Moving in circle around planet following mouse

	var mousePos := get_global_mouse_position()
	if !isPlayer:
		mousePos = target.global_position
	var targetDirection: Vector2 = ( mousePos - get_parent().global_position).normalized()
	self.position = targetDirection * radius;
	var angle := atan2(targetDirection.y, targetDirection.x) + PI * 0.5
	self.rotation = angle
	
	# Animation of laser
	coolDownTimer = max(coolDownTimer - delta, 0.0)
	laserLine.visible = coolDownTimer > 0.01
	var alpha: float = -(4.0 * (coolDownTimer - shotCooldown)) * (4.0 * (coolDownTimer - shotCooldown)) + 1.0
	
	laserLine.default_color = Color(172.0 / 255.0, 50.0 / 255.0, 50.0 / 255.0, alpha)
	self.texture = activeLaser if coolDownTimer > shotCooldown - 0.1 else unActiveLaser
	


	
	# Input for shot
	if laserLine != null:
		if !isPlayer and coolDownTimer < 0.01:
			coolDownTimer = shotCooldown
			needsToShot = true
			bought = false
		if isPlayer == true && Input.is_action_just_pressed("click") and coolDownTimer < 0.01:
			coolDownTimer = shotCooldown
			needsToShot = true
			bought = false


func _physics_process(delta):
	# Raycast planets
	
	var mousePos := get_global_mouse_position()
	var targetDirection: Vector2 = (mousePos - laserLine.global_position).normalized()
	
	if coolDownTimer > 0.01:
		needsToShot = false
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
		else:
			laserLine.points[0] = laserLine.position
			laserLine.points[1] = laserLine.position + Vector2(0, -MAX_LASER_DST)
