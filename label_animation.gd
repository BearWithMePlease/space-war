extends RichTextLabel

@export var duration: float = 2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	visible_ratio = 0

func play_animation():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "visible_ratio", 1.0, duration).set_trans(Tween.TransitionType.TRANS_LINEAR)
