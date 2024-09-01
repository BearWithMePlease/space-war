extends Control

@export var start_population: int
@export var count_label: Label
@export var GUI_Label: Label
@export var GUI_Text: String = "Population:"
@export var death_label: Label
@export var MIN_PEOPLE_GROW_CYCLE_TIME:int = 5
@export var MAX_PEOPLE_GROW_CYCLE_TIME:int = 15
@export var MAX_GROWTH_FACTOR: float = 0.01
@export var MIN_GROWTH_FACTOR: float = 0.001
@export var DAMAGE_COLOR: Color
@export var GROWTH_COLOR: Color

var population:int
var cycle_time = 0
var current_grow_time:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	current_grow_time = randf_range(MIN_PEOPLE_GROW_CYCLE_TIME, MAX_PEOPLE_GROW_CYCLE_TIME)
	population = start_population
	update_label()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cycle_time += delta
	
	if cycle_time >= current_grow_time:
		cycle_time = 0
		current_grow_time = randf_range(MIN_PEOPLE_GROW_CYCLE_TIME, MAX_PEOPLE_GROW_CYCLE_TIME)
		
		# Population growth
		var new_population = population * randf_range(MIN_GROWTH_FACTOR, MAX_GROWTH_FACTOR)
		population += new_population
		update_label()
		label_animation(new_population, false)

func update_label():
	var txt = get_k_string(population)
	count_label.text = txt
	GUI_Label.text = GUI_Text + txt

func is_dead() -> bool:
	return population == 0

# Count Death, returns true if population is still alive
func take_hit(kill_count:int) -> bool:
	var actual_kills = min(kill_count, population)
	population -= actual_kills
	
	update_label()
	label_animation(actual_kills, true)
	return population == 0

func label_animation(count:int, is_damage:bool):
	var label:Label = death_label.duplicate()
	count_label.add_child(label)
	
	label.text =  ("-" if is_damage else "+") + get_k_string(count)
	
	# set color: red=damage && green=growth
	var color_fade = Color(1,1,1,0)
	label.modulate = Color(1,1,1,1)
	label.label_settings.font_color = DAMAGE_COLOR if is_damage else GROWTH_COLOR
	
	# Randomize x position so multiple msgs are still visible
	label.position.x = randi_range(label.position.x - label.size.x / 2, label.position.x + label.size.x / 2)
	var new_position = Vector2(label.position.x, label.position.y - 50)
	
	# animation: flow to top and vanish
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(label, "position", new_position, 3).set_trans(Tween.TransitionType.TRANS_LINEAR)
	tween.tween_property(label, "modulate", color_fade, 4).set_trans(Tween.TransitionType.TRANS_QUART)
	
	await get_tree().create_timer(4).timeout
	label.queue_free() # destroy node after invisible (after 4s)

func get_k_string(number: int):
	if number < 100_000: return str(number)
	if number < 10_000_000: return str(number / 1_000) + "k"
	return str(number / 1_000_000) + "M"
