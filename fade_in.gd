extends ColorRect

@export var fade_color: Color
@export var fade_duration: float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = true
	self.color = fade_color
	
	var a_color = fade_color
	a_color.a = 0
	
	var tween = get_tree().create_tween()
	tween.tween_property(self, "color", a_color, fade_duration).set_trans(Tween.TransitionType.TRANS_LINEAR)
	
	await get_tree().create_timer(fade_duration).timeout
	self.visible = false
