extends Panel

@export var seconds: float = 1.0
@export var transition_type: Tween.TransitionType = Tween.TransitionType.TRANS_LINEAR

@export var hidden_position: Vector2
@export var visible_position: Vector2
@export var labels_prices:Array[Label]
@export var default_price_label:String = "Build for"
@export var starting_prices:Array[int]
@export var FACTORY_INDEX:int
@export var FACTORY_COST_GROW_FACTORY:int = 20
@export var NEW_SLOT_INDEX:int
@export var SLOT_COST_GROW_FACTORY:int = 22
@export var arrow_image: TextureRect
@export var position_hidden: Control
@export var position_visible: Control

var current_state: String = "hidden"
var current_prices: Array[int] = []
var mouse_over_arrow: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	shop_animation("position", position_hidden.position, true)
	
	current_prices = []
	for index in starting_prices.size():
		current_prices.append(starting_prices[index])
		update_price(index)

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click") and mouse_over_arrow:
		arrow_image.flip_h = !arrow_image.flip_h
		if current_state == "hidden":
			current_state = "visible"
			shop_animation("position", position_visible.position)
			$"../../AudioPlayer".play_sound($"../../AudioPlayer".SoundType.SHOP_WINDOW)
			var camera := $"../../Camera2D" as PanZoomCamera
			if camera != null:
				camera.setActive(false)
		elif current_state == "visible":
			current_state = "hidden"
			shop_animation("position", position_hidden.position)
			$"../../AudioPlayer".play_sound($"../../AudioPlayer".SoundType.SHOP_WINDOW)
			var camera := $"../../Camera2D" as PanZoomCamera
			if camera != null:
				camera.setActive(true)

func update_price(index:int):
	if labels_prices[index] != null:
		labels_prices[index].text = default_price_label + " " + str(current_prices[index])

func change_mouse_over_arrow(status:bool):
	mouse_over_arrow = status

func shop_animation(property: String, value, instant: bool = false):
	var tween = get_tree().create_tween()
	var timing = 0.01 if instant else seconds
	tween.tween_property(self, property, value, timing).set_trans(transition_type)

func _on_item_buy(index: int) -> void:
	if $"../Stats/Money".can_obtain_item(index):
		$"../Stats/Money".buy_item(current_prices[index])     # Buy first
		$"../Inventory".add_item(index)                # Then maybe change price
		
		if index == Inventory.ITEM_TYPES.FACTORY:
			$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.BUILD_FACTORY)
		elif index == Inventory.ITEM_TYPES.SLOT:
			$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.UNLOCK_SLOT)
		else:
			$"../../AudioPlayer".play_sound(AudioPlayer.SoundType.SOUND_BUTTON_CLICK)

func build_factory(factory_count: int):
	current_prices[FACTORY_INDEX] += ceil((FACTORY_COST_GROW_FACTORY + factory_count) ** 2 / 100) * 100
	update_price(FACTORY_INDEX)

func add_new_slot(slot_count: int):
	current_prices[NEW_SLOT_INDEX] += ceil((SLOT_COST_GROW_FACTORY + slot_count) ** 2 / 100) * 100
	update_price(NEW_SLOT_INDEX)
