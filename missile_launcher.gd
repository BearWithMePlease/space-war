extends Node2D

@export var missile: PackedScene = null
@export var asteroid: PackedScene = null
@export var asteroidSprites: Array[Texture2D] = []

func launch_missile(target: Node2D):
	var new_missile = missile.instantiate()
	new_missile.target = target
	new_missile.launcher = self
	$"../../..".add_child(new_missile)

func launch_asteroid(target: Node2D, player:bool):
	var new_asteroid := asteroid.instantiate() as Asteroid
	new_asteroid.initialize(self, target, asteroidSprites.pick_random())
	var mouse_position := get_global_mouse_position()
	new_asteroid.isPlayer = player
	$"../../..".add_child(new_asteroid)
	
	
