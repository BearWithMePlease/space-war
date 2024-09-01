extends Button

func _open_github() -> void:
	$"../../../AudioPlayer".play_sound(AudioPlayer.SoundType.SOUND_BUTTON_CLICK)
	OS.shell_open("https://github.com/BearWithMePlease/space-war")
