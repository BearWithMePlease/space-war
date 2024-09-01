extends Node2D

class_name Shield

@export var shieldCount: int = 0
@export var firstShieldSprite: Sprite2D = null
@export var firstShieldArea: Area2D = null
@export var secondShieldSprite: Sprite2D = null
@export var secondShieldArea: Area2D = null
@export var rotationSpeed: float = 2.0

func addShield() -> bool:
	if shieldCount >= 2:
		return false
	
	#if firstShieldSprite.visible == false:
		#firstShieldSprite.visible = true
	#else:
		#secondShieldSprite.visible = true
	shieldCount += 1
	$"../../../AudioPlayer".play_sound(AudioPlayer.SoundType.SHIELD_ACTIVATE)

	updateVisible()
	return true

#func removeSpecificShield(number):
	#if number == 1:
		#firstShieldSprite.visible = false
		#shieldCount -= 1
	#if number == 2:
		#secondShieldSprite.visible = false
		#shieldCount -= 1

func removeShield() -> bool:
	pass
	if shieldCount <= 0:
		return false
	shieldCount -= 1
	updateVisible()
	return true

func updateVisible() -> void:
	if firstShieldSprite != null:
		firstShieldSprite.visible = shieldCount >= 1
		(firstShieldArea.get_child(0) as CollisionPolygon2D).disabled = !(shieldCount >= 1)
	if secondShieldSprite != null:
		secondShieldSprite.visible = shieldCount >= 2
		(secondShieldArea.get_child(0) as CollisionPolygon2D).disabled = !(shieldCount >= 2)
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	updateVisible()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateVisible()
	
	if firstShieldSprite != null:
		firstShieldSprite.rotate(rotationSpeed * delta)
	if secondShieldSprite != null:
		secondShieldSprite.rotate(rotationSpeed * delta)
