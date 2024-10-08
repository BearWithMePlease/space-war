extends ParallaxBackground

@export var camera: Camera2D = null
@export var effect: float = 50.0

var mouse_in_window: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not mouse_in_window: return
	var viewport_rect := get_viewport().get_visible_rect()
	var mouse_pos = get_viewport().get_mouse_position()
	var mouse_offset = mouse_pos / viewport_rect.size - Vector2.ONE * 0.5
	
	camera.offset = lerp(camera.offset, mouse_offset * effect, 10.0 * delta)

func _notification(what):
	if what == NOTIFICATION_WM_MOUSE_ENTER:
		mouse_in_window = true
	elif what == NOTIFICATION_WM_MOUSE_EXIT:
		mouse_in_window = false
