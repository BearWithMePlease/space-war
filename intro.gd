extends CanvasLayer

@export var panels: Array[Control]
@export var txts: Array[RichTextLabel]
@export var time_per_char:float = 0.07
@export var audio_player: AudioStreamPlayer
@export var war_audio_player: AudioStreamPlayer
@export var paper_fluter_player: AudioStreamPlayer
@export var progress_label: Label

var current_panel: int = -1
var loading_scene = false
var scene: Main.GameState

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	progress_label.visible = false
	
	for txt in txts:
		txt.visible_ratio = 0
	
	for panel in panels:
		panel.visible = false
	
	next_panel()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("click"):
		if current_panel != 5:
			next_panel()
	if loading_scene:
		var progress: Array[float] = [0]
		if scene == Main.GameState.PLAYING:
			ResourceLoader.load_threaded_get_status("res://node_2d.tscn", progress)
		elif scene == Main.GameState.TUTORIAL:
			ResourceLoader.load_threaded_get_status("res://tutorial.tscn", progress)
			
		if progress[0] >= 1:
			if scene == Main.GameState.PLAYING:
				$"..".change_state(Main.GameState.PLAYING)
			elif scene == Main.GameState.TUTORIAL:
				$"..".change_state(Main.GameState.TUTORIAL)
		else:
			progress_label.text = "Progress: " + str(floori(progress[0] * 100)) + "%"

func next_panel():
	audio_player.playing = false
	war_audio_player.playing = false
	paper_fluter_player.playing = false
	
	if current_panel != -1:
		# Fade out
		panels[current_panel].visible = false

	current_panel += 1
	
	panels[current_panel].visible = true
	play_animation(txts[current_panel])
	
	if current_panel == 0 or current_panel == 4:
		war_audio_player.playing = true
		
	if current_panel == 2:
		paper_fluter_player.playing = true
	
func player_paper_flutter():
	paper_fluter_player.playing = true

func play_animation(txt: RichTextLabel):
	var tween = get_tree().create_tween()
	var duration = txt.get_total_character_count() * time_per_char
	tween.tween_property(txt, "visible_ratio", 1.0, duration).set_trans(Tween.TransitionType.TRANS_LINEAR)
	
	if current_panel != 0 and current_panel != 5:
		audio_player.playing = true
		await get_tree().create_timer(duration).timeout
		audio_player.playing = false

func finished_intro(tutorial:bool):
	loading_scene = true
	progress_label.visible = true
	if tutorial:
		scene = Main.GameState.TUTORIAL
		#$"..".change_state(Main.GameState.TUTORIAL)
	else:
		scene = Main.GameState.PLAYING
		#$"..".change_state(Main.GameState.PLAYING)
