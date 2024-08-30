extends HBoxContainer

@export var MAX_SLOT_SIZE:int = 5
@export var START_SLOT_SIZE:int = 5

@export var slots: Array[TextureRect] = []
@export var type_images: Array[CompressedTexture2D] = []
@export var FACTORY_INDEX:int
@export var NEW_SLOT_INDEX:int
@export var start_slot_count:int

var used_slots:int = 0
var available_slots: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	available_slots = start_slot_count

func can_add_item():
	return used_slots < available_slots

func add_item(type: int):
	if type == FACTORY_INDEX: 
		build_factory()
	elif type == NEW_SLOT_INDEX:
		add_new_slot()
	elif can_add_item():
		slots[used_slots].texture = type_images[type]
		used_slots += 1

func build_factory():
	$"../money".build_factory()
	$"../Shop".build_factory($"../money".factory_count)
	
func add_new_slot():
	if available_slots <= MAX_SLOT_SIZE:
		slots[available_slots].texture = null
		available_slots += 1
		$"../Shop".add_new_slot(available_slots)
