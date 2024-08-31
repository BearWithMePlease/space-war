extends HBoxContainer

@export var MAX_SLOT_SIZE:int = 5
@export var START_SLOT_SIZE:int = 5

@export var slots: Array[TextureRect] = []
@export var type_images: Array[CompressedTexture2D] = []
@export var rocket_prefab: PackedScene
@export var rocket_parent: Node2D
@export var mars: Planet

var slotItems: Array[ITEM_TYPES] = []

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
	var i := 0
	for slotIcon in slots:
		slotIcon.texture = type_images[slotItems[i]] if slotItems[i] != ITEM_TYPES.EMPTY else null
		i += 1
	add_new_slot()
	add_new_slot()

func can_add_item():
	for item in slotItems:
		if item == ITEM_TYPES.EMPTY:
			return true
	return false

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
				break

func remove_item_at(slotIndex: int):
	slots[slotIndex].texture = null
	slotItems[slotIndex] = ITEM_TYPES.EMPTY

func _useItemInSlot(slotIndex: int) -> void:
	if slotItems[slotIndex] == ITEM_TYPES.SHIELD:
		if $"../../Planets/mars/Shield".addShield():
			remove_item_at(slotIndex)
	elif slotItems[slotIndex] == ITEM_TYPES.ROCKET:
		#var rocket := rocket_prefab.instantiate() as Rocket
		#rocket.position = mars.position
		#rocket_parent.add_child(rocket)
		
		remove_item_at(slotIndex)

func build_factory() -> void:
	$"../Money".build_factory()
	$"../Shop".build_factory($"../Money".factory_count)
	
func add_new_slot() -> bool:
	for slotIndex in range(slotItems.size()):
		if slotItems[slotIndex] == ITEM_TYPES.LOCKED:
			slotItems[slotIndex] = ITEM_TYPES.EMPTY
			slots[slotIndex].texture = null
			return true
	return false
