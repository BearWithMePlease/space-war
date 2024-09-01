extends Node
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

@export var current_state: GameState = GameState.PLAYING

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	print("jeff") # Call jeff.
	
	self.get_tree().paused = false
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	for child:Node in self.get_children():
		if child.process_mode == Node.PROCESS_MODE_INHERIT:
			child.process_mode = Node.PROCESS_MODE_PAUSABLE

func change_state(state:GameState):
	if current_state == state: 
		return
	print("change scene to: " + str(state))
	
	if current_state == GameState.MENU:
		$AudioPlayer.play_sound(AudioPlayer.SoundType.SOUND_BUTTON_CLICK)
	
	if state == GameState.PAUSE:
		if pause_panel != null:
			pause_panel.visible = true
		if victory_panel != null:
			victory_panel.visible = false
		set_pause_mode(false)
	elif current_state == GameState.PAUSE and state == GameState.PLAYING:
		if pause_panel != null:
			pause_panel.visible = false
		if victory_panel != null:
			victory_panel.visible = false
		set_pause_mode(true)
	elif state == GameState.VICTORY or state == GameState.DEFEAT:
		$GUI/GameEndPanel/Container/Stats.update_stats(state == GameState.VICTORY)
		pause_panel.visible = false
		victory_panel.visible = true
		set_pause_mode(false)
	elif state == GameState.MENU:
		print("From play to menu")
		set_pause_mode(false)
		get_tree().change_scene_to_file("res://menu.tscn")
	elif current_state == GameState.INTRO and state == GameState.PLAYING:
		print("From menu to play")
		set_pause_mode(false)
		get_tree().change_scene_to_file("res://node_2d.tscn")
	elif current_state == GameState.MENU and state == GameState.INTRO:
		print("From menu to intro")
		set_pause_mode(false)
		get_tree().change_scene_to_file("res://intro.tscn")
	
	current_state = state
	
func set_pause_mode(enabled: bool):
	if self.get_tree() != null:
		self.get_tree().paused = not enabled
