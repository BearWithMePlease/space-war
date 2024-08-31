extends Control

@export var start_population: int
@export var count_label: Label
@export var death_label: Label
@export var PEOPLE_GROW_CYCLE_TIME:int = 1
@export var MAX_GROWTH_FACTOR: float = 1.01
@export var MIN_GROWTH_FACTOR: float = 1.001

var population:int
var cycle_time = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	population = start_population

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cycle_time += delta
	
	if cycle_time >= PEOPLE_GROW_CYCLE_TIME:
		cycle_time = 0
		
		# Population growth
		population *= randf_range(MIN_GROWTH_FACTOR, MAX_GROWTH_FACTOR)
		update_label()
		
		take_hit(1000)
		
func update_label():
	count_label.text = str(population)

# Count Death, returns true if population is still alive
func take_hit(kill_count:int) -> bool:
	var actual_kills = min(kill_count, population)
	
	population -= actual_kills
	update_label()
	hit_animation(actual_kills)
	return population == 0

func hit_animation(kill_count:int):
	var label = death_label.duplicate()
	
	count_label.add_child(label)
	
	label.text = str(-kill_count)
	var new_position = Vector2(label.position.x, label.position.y - 50)
	var color_fade = Color(1,1,1,0)
	label.modulate = Color(1,1,1,1)
	
	var tween = get_tree().create_tween()
	tween.set_parallel()
	tween.tween_property(label, "position", new_position, 3).set_trans(Tween.TransitionType.TRANS_LINEAR)
	tween.tween_property(label, "modulate", color_fade, 4).set_trans(Tween.TransitionType.TRANS_QUART)
	
	await get_tree().create_timer(4).timeout
	label.queue_free() # destroy node
