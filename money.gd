extends Label

@export var START_BALANCE:int
@export var MONEY_CYCLE_TIME:int
@export var BASE_EARN:int
@export var FACTORY_EARN:int
@export var LABEL: String = "Energy Deposit"
@export var item_buttons: Array[Button]

var balance: int
var cycle_time = 0

var factory_count = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	balance = START_BALANCE
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cycle_time += delta
	
	if cycle_time >= MONEY_CYCLE_TIME:
		cycle_time = 0
		balance += get_total_earn()
		update_label()
		update_buttons()

func update_label():
	self.text = LABEL + " (" + str(get_total_earn()) + "/s):" + " " + str(balance)

func update_buttons():
	for index in $"../Shop".current_prices.size():
		if balance >= $"../Shop".current_prices[index] and can_obtain_item(index):
			item_buttons[index].disabled = false
			item_buttons[index].mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		else:
			item_buttons[index].disabled = true
			item_buttons[index].mouse_default_cursor_shape = Control.CURSOR_ARROW
 
func can_obtain_item(index: int):
	return $"../Inventory".can_add_item() || index == $"../Inventory".FACTORY_INDEX || index == $"../Inventory".NEW_SLOT_INDEX

func get_total_earn():
	return BASE_EARN + factory_count * FACTORY_EARN

func build_factory():
	factory_count += 1

func buy_item(value:int):
	balance -= value
	update_label()
	update_buttons()
