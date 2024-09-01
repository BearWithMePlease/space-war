extends VBoxContainer

@export var BONUS_FACTOR:float = 0.01
@export var title: Label
@export var casualties:RichTextLabel
@export var shame_info:RichTextLabel
@export var score:RichTextLabel
@export var victory_color: Color
@export var defeat_color: Color

func update_stats(is_victory: bool):
	if is_victory:
		title.text = "Victory"
		title.add_theme_color_override("font_color", victory_color)
	else:
		title.text = "Defeat"
		title.add_theme_color_override("font_color", defeat_color)
	
	var mars_casualties = $"../../../../Planets/mars/Population".casualties
	var earth_casualties = $"../../../../Planets/earth/Population".casualties
	var score_int = ceili((earth_casualties - mars_casualties) * BONUS_FACTOR)
	
	# Defeat: max 0 && Victory: min 0
	if is_victory and score_int < 0:
		score_int = 0
	if not is_victory and score_int > 0:
		score_int = 0
	
	# Rich Text magic
	casualties.text = "[center][color=ac3232]" + Population.get_k_string(mars_casualties) + "[/color] Martians[/center]" + '\n' + "[center][color=ac3232]" + Population.get_k_string(earth_casualties) + "[/color] Earthlings[/center]"
	shame_info.text = "[center]Your actions have killed [color=ac3232]" + Population.get_k_string(mars_casualties + earth_casualties)  + "[/color] Civilians[/center]"
	score.text = "[center]Your Score: [color=FBF236]" + Population.get_k_string(score_int) + "[/color][/center]"
