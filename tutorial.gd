extends Node2D

@export var listOfSlides: Array[Label] = []
@export var stats: Control = null
@export var shops: Control = null
@export var inventory: Control = null
var currentState: SLIDES = SLIDES.TRY_CAMERA

enum SLIDES {
	TRY_CAMERA = 0,
	CHECK_ENERGY = 1,
	OPEN_SHOP = 2,
	BUY_ITEM = 3,
	USE_ITEM = 4,
	ENJOY = 5,
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats.visible = false
	shops.visible = false
	inventory.visible = false
	updateSlides()
	
func _process(delta: float) -> void:
	if currentState == SLIDES.TRY_CAMERA:
		if Input.is_action_pressed("zoom_in") || Input.is_action_pressed("zoom_out") || Input.is_action_pressed("camera_drag"):
			print("trying")
			_prodceedTutorial(int(SLIDES.CHECK_ENERGY))
			
	var shopOpen := $"../GUI/Shop".current_state == "visible" as bool
	if currentState == SLIDES.OPEN_SHOP and shopOpen:
		_prodceedTutorial(int(SLIDES.BUY_ITEM))
		
func _unhandled_key_input(event):
	if event.is_pressed():
		if currentState == SLIDES.CHECK_ENERGY:
			_prodceedTutorial(int(SLIDES.OPEN_SHOP))
		elif currentState == SLIDES.ENJOY:
			$"..".change_state(Main.GameState.PLAYING)
		
func _prodceedTutorial(index: int) -> void:
	currentState = index as SLIDES
	updateSlides()
	
func updateSlides() -> void:
	var increment := 0
	for slide in listOfSlides:
		if slide != null:
			slide.visible = increment == int(currentState)
		increment += 1
		
	if currentState >= SLIDES.CHECK_ENERGY:
		stats.visible = true
	if currentState >= SLIDES.OPEN_SHOP:
		shops.visible = true
	if currentState >= SLIDES.USE_ITEM:
		inventory.visible = true
