extends AudioStreamPlayer

@export var sounds: Array[AudioStreamMP3]
@export var change_volume: Array[int]

enum SoundType {
	ASTEROID_LAUNCH_SOUND = 0,
	GAME_BACKGROUND_MUSIC = 1,
	INTRO_BACKGROUND_MUSIC = 2,
	LASER_LAUNCH_SOUND = 3,
	ROCKET_LAUNCH_SOUND = 4,
	SOUND_BUTTON_CLICK = 5,
	SHIELD_ACTIVATE = 6,
	SHOP_WINDOW = 7,
	SLOT_SELECT = 8
}

func play_sound(type: SoundType):
	var player: AudioStreamPlaybackPolyphonic = self.get_stream_playback()
	var channel_id = player.play_stream(sounds[type], 0, change_volume[type])
	return channel_id

func stop_sound(channel_id: int):
	var player: AudioStreamPlaybackPolyphonic = self.get_stream_playback()
	player.stop_stream(channel_id)
