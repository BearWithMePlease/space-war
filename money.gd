extends Label

@export var START_BALANCE:int
@export var MONEY_CYCLE_TIME:int
@export var BASE_EARN:int
@export var FACTORY_EARN:int
@export var LABEL: String = "Energy Deposit"

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
		

func update_label():
	self.text = LABEL + " (" + str(get_total_earn()) + "/s):" + " " + str(balance)

func get_total_earn():
	return BASE_EARN + factory_count * FACTORY_EARN
