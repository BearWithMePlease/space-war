extends Node2D
class_name Main

@export var pause_panel: Panel
@export var victory_panel: Panel
@export var defeat_panel: Panel

enum GameState {
	MENU = 0,
	INTRO = 1,
	PLAYING = 2,
	PAUSE = 3,
	DEFEAT = 4,
	VICTORY = 5
}

var current_state: GameState = GameState.PLAYING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("jeff") # Call jeff.
	
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	for child:Node in self.get_children():
		if child.process_mode == Node.PROCESS_MODE_INHERIT:
			child.process_mode = Node.PROCESS_MODE_PAUSABLE

func change_state(state:GameState):
	if current_state == state: return

	current_state = state
	
	if state == GameState.PAUSE:
		pause_panel.visible = true
		victory_panel.visible = false
		set_pause_mode(false)
	elif state == GameState.PLAYING:
		pause_panel.visible = false
		victory_panel.visible = false
		set_pause_mode(true)
	elif state == GameState.VICTORY or state == GameState.DEFEAT:
		$GUI/GameEndPanel/Container/Stats.update_stats(state == GameState.VICTORY)
		
		pause_panel.visible = false
		victory_panel.visible = true
		set_pause_mode(true)
	
func set_pause_mode(enabled: bool):
	self.get_tree().paused = not enabled
