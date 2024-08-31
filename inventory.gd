extends HBoxContainer
class_name Inventory

@export var MAX_SLOT_SIZE:int = 5
@export var START_SLOT_SIZE:int = 5

@export var slots: Array[TextureRect] = []
@export var type_images: Array[CompressedTexture2D] = []
@export var cooldown_images: Array[ColorRect] = []
@export var rocket_prefab: PackedScene
@export var rocket_parent: Node2D
@export var mars: Planet
@export var earth: Planet
@export var default_cooldown: int = 2
@export var shield_cooldown: int = 5

var slotItems: Array[ITEM_TYPES] = []
var cooldowns: Array[bool] = []

enum ITEM_TYPES {
	EMPTY = -1,
	FACTORY = 0, 
	SLOT = 1,
	SHIELD = 2, 
	ASTEROID = 3, 
	ROCKET = 4, 
	LASER = 5,
	LOCKED = 6,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	slotItems.resize(6)
	slotItems.fill(ITEM_TYPES.LOCKED)
	cooldowns.resize(6)
	var i := 0
	for slotIcon in slots:
		slotIcon.texture = type_images[slotItems[i]] if slotItems[i] != ITEM_TYPES.EMPTY else null
		i += 1
	add_new_slot()
	add_new_slot()

# Check if the are empty slots
func can_add_item():
	for item in slotItems:
		if item == ITEM_TYPES.EMPTY:
			return true
	return false

# Bought item: Does not add to inv if Factory/New_Slot && Check if possible otherwise
func add_item(type: int):
	if type == ITEM_TYPES.FACTORY: 
		build_factory()
	elif type == ITEM_TYPES.SLOT:
		add_new_slot()
	elif can_add_item():
		for slotIndex in range(slotItems.size()):
			if slotItems[slotIndex] == ITEM_TYPES.EMPTY:
				slots[slotIndex].texture = type_images[type]
				slotItems[slotIndex] = type as ITEM_TYPES
				
				if type == ITEM_TYPES.SHIELD:
					set_cooldown(slotIndex, shield_cooldown)
				else:
					set_cooldown(slotIndex, default_cooldown)
				break

func set_cooldown(slotIndex:int, seconds: int):
	
	cooldowns[slotIndex] = true
	
	# animate
	cooldown_images[slotIndex].size = Vector2(88, 88)
	cooldown_images[slotIndex].position = Vector2(6, 6)
	
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(cooldown_images[slotIndex], "position", Vector2(6, 94), seconds).set_trans(Tween.TransitionType.TRANS_LINEAR)
	tween.tween_property(cooldown_images[slotIndex], "size", Vector2(88, 0), seconds).set_trans(Tween.TransitionType.TRANS_LINEAR)
	
	# wait for cooldown to finish and enable slot use
	await get_tree().create_timer(seconds).timeout
	cooldowns[slotIndex] = false

# Set Slot image to null
func remove_item_at(slotIndex: int):
	slots[slotIndex].texture = null
	slotItems[slotIndex] = ITEM_TYPES.EMPTY

func _useItemInSlot(slotIndex: int) -> void:
	# check if slot was recently bought (cooldown)
	if cooldowns[slotIndex]: return
	
	if slotItems[slotIndex] == ITEM_TYPES.SHIELD:
		if $"../../Planets/mars/Shield".addShield():
			remove_item_at(slotIndex)
			$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.SHIELD_ACTIVATE)
	elif slotItems[slotIndex] == ITEM_TYPES.ROCKET:
		$"../../Planets/mars/Missile Launcher".launch_missile(earth)
		remove_item_at(slotIndex)
		$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.ROCKET_LAUNCH_SOUND)
	elif slotItems[slotIndex] == ITEM_TYPES.LASER:
		if $"../../Planets/mars/Laser".addLaserSatelite():
			remove_item_at(slotIndex)
			$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.LASER_LAUNCH_SOUND)
	elif slotItems[slotIndex] == ITEM_TYPES.ASTEROID:
		$"../../Planets/mars/Missile Launcher".launch_asteroid(earth)
		remove_item_at(slotIndex)
		$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.ASTEROID_LAUNCH_SOUND)

# Build Factory: Money -> +1 Factory && Shop update Factory price
func build_factory() -> void:
	$"../Money".build_factory()
	$"../Shop".build_factory($"../Money".factory_count)

# Check if there are LOCKED slots
func can_add_new_slot() -> bool:
	for slotIndex in range(slotItems.size()):
		if slotItems[slotIndex] == ITEM_TYPES.LOCKED:
			return true
	return false

# Add bought item to leftest empty slot
func add_new_slot() -> bool:
	for slotIndex in range(slotItems.size()):
		if slotItems[slotIndex] == ITEM_TYPES.LOCKED:
			slotItems[slotIndex] = ITEM_TYPES.EMPTY
			slots[slotIndex].texture = null
			return true
	return false

# Play click sound on slot select
func on_focus():
	$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.SLOT_SELECT)
