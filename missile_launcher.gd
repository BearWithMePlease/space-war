extends Node2D

@export var missile: PackedScene = null
@export var asteroid: PackedScene = null
@export var asteroidSprites: Array[Texture2D] = []


var object_struck_shield1 = false
var object_struck_shield2 = false

var smoke = preload("res://smoke.tscn")


func launch_missile(target: Node2D):
	var new_missile = missile.instantiate()
	new_missile.target = target
	new_missile.launcher = self
	new_missile.sun = $"../../sun"
	new_missile.venus = $"../../venus"
	new_missile.mercury = $"../../mercury"
	
	var new_smoke = smoke.instantiate()
	new_smoke.target = target
	new_smoke.launcher = self
	new_smoke.position = Vector2(0,0)
	self.add_child(new_smoke)
	
	$"../../..".add_child(new_missile)

func launch_asteroid(target: Node2D, player:bool):
	var new_asteroid := asteroid.instantiate() as Asteroid
	new_asteroid.initialize(self, target, asteroidSprites.pick_random())
	var mouse_position := get_global_mouse_position()
	new_asteroid.isPlayer = player
	new_asteroid.sun = $"../../sun"
	new_asteroid.venus = $"../../venus"
	new_asteroid.mercury = $"../../mercury"
	$"../../..".add_child(new_asteroid)
	
	


	
func _on_area_2d_area_entered2(area: Area2D) -> void:
	object_struck_shield1 = true

	


func _on_area_2d_area_entered(area: Area2D) -> void:
	object_struck_shield2 = true
