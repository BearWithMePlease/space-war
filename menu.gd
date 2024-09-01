extends Panel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("escape") and self.name == "PausePanel":
		if $"../..".current_state == Main.GameState.PLAYING:
			$"../..".change_state(Main.GameState.PAUSE)
		elif $"../..".current_state == Main.GameState.PAUSE:
			$"../..".change_state(Main.GameState.PLAYING)

func _on_resume_button_down() -> void:
	$"../..".change_state(Main.GameState.PLAYING)


func _on_quit_to_menu_button_down() -> void:
	pass # Replace with function body.
