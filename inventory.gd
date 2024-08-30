extends HBoxContainer

@export var MAX_SLOT_SIZE:int = 5
@export var START_SLOT_SIZE:int = 5

@export var slots: Array[TextureRect] = []
@export var type_images: Array[CompressedTexture2D] = []


var used_slots:int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func can_add_item():
	return used_slots <= MAX_SLOT_SIZE

func add_item(type: int):
	if not can_add_item(): return
	
	slots[used_slots].texture = type_images[type]
	used_slots += 1
