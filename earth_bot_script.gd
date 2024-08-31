extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var mars = $"../Planets/mars"

@onready var earth = $"../Planets/earth"
@onready var earth_launcher = $"../Planets/earth/Missile Launcher"
@onready var earth_shield = $"../Planets/earth/Shield"
@onready var earth_lazer = $"../Planets/earth/Laser"

func _on_start_of_match_timeout() -> void:
	earth_shield.addShield()
	await get_tree().create_timer(2.0).timeout
	earth_shield.addShield()
	
	print("first round of protection")
	
	
@onready var probing_shot_timer = $probing_shot
func _on_probing_shot_timeout() -> void:
	

	while abs(Vector2(earth.position.x-mars.position.x, earth.position.y-mars.position.y).length()) < 400:
		#print(Vector2(earth.position.x-mars.position.x, earth.position.y-mars.position.y).length())
		#print("IM WAITING")
		await get_tree().create_timer(0.5).timeout
	
	earth_launcher.launch_missile(mars)
	print("first missile fired")
	
	
	
	#IF earth takes dmg => launch 2 more
	await get_tree().create_timer(2.0).timeout # replace with if

	while abs(Vector2(earth.position.x-mars.position.x, earth.position.y-mars.position.y).length()) < 400:
		#print(Vector2(earth.position.x-mars.position.x, earth.position.y-mars.position.y).length())
		#print("IM WAITING")
		await get_tree().create_timer(0.5).timeout
	
	earth_launcher.launch_missile(mars)
	await get_tree().create_timer(0.5).timeout
	earth_launcher.launch_missile(mars)

	probing_shot_timer.wait_time = randi_range(20,30)
	

@onready var on_melee_timer = $melee_asteroid
func _on_melee_asteroid_timeout() -> void:
	while abs(Vector2(earth.position.x-mars.position.x, earth.position.y-mars.position.y).length()) > 130:
		#print(Vector2(earth.position.x-mars.position.x, earth.position.y-mars.position.y).length())
		#print("IM WAITING")
		await get_tree().create_timer(0.5).timeout
		
	earth_launcher.launch_asteroid(mars,false)
	
	on_melee_timer.wait_time = randi_range(20,30)
	
	


func _on_random_lazer_poke_timeout() -> void:
	
	earth_lazer.addLaserSatelite($"../Planets/mars",false)
	pass # Replace with function body.
