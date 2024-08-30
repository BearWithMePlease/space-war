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
@export var SLOT_COST_GROW_FACTORY:int = 20

var current_state: String = "hidden"
var current_prices: Array[int] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.position = hidden_position
	
	for index in starting_prices.size():
		current_prices.append(starting_prices[index])
		update_price(index)

func update_price(index:int):
	labels_prices[index].text = default_price_label + " " + str(current_prices[index])

func _on_control_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if current_state == "hidden":
			current_state = "visible"
			shop_animation("position", visible_position)
		elif current_state == "visible":
			current_state = "hidden"
			shop_animation("position", hidden_position)

func _on_close_button_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if current_state == "visible":
			current_state = "hidden"
			shop_animation("position", hidden_position)


func shop_animation(property: String, value):
	var tween = get_tree().create_tween()
	tween.tween_property(self, property, value, seconds).set_trans(transition_type)


func _on_item_buy(index: int) -> void:
	$"../Inventory".add_item(index)

func build_factory(factory_count: int):
	current_prices[FACTORY_INDEX] += ceil((FACTORY_COST_GROW_FACTORY + factory_count) ** 2 / 100) * 100
	update_price(FACTORY_INDEX)

func add_new_slot(slot_count: int):
	current_prices[NEW_SLOT_INDEX] += ceil((SLOT_COST_GROW_FACTORY + slot_count) ** 2 / 100) * 100
	update_price(NEW_SLOT_INDEX)
