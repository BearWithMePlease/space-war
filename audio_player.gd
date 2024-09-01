extends AudioStreamPlayer
class_name AudioPlayer

@export var sounds: Array[AudioStreamMP3]
@export var change_volume: Array[int]
@export var MIN_VOLUME:float = -30.0
@export var MAX_VOLUME:float = 20.0
@export var DEFAULT_VOLUME:float = 50.0

enum SoundType {
	ASTEROID_LAUNCH_SOUND = 0,
	GAME_BACKGROUND_MUSIC = 1,
	INTRO_BACKGROUND_MUSIC = 2,
	LASER_LAUNCH_SOUND = 3,
	ROCKET_LAUNCH_SOUND = 4,
	SOUND_BUTTON_CLICK = 5,
	SHIELD_ACTIVATE = 6,
	SHOP_WINDOW = 7,
	SLOT_SELECT = 8,
	UNLOCK_SLOT = 9,
	BUILD_FACTORY = 10,
	SHIELD_BREAK = 11,
}

func _ready() -> void:
	_on_volume_slider_value_changed(DEFAULT_VOLUME)

func play_sound(type: SoundType):
	var player: AudioStreamPlaybackPolyphonic = self.get_stream_playback()
	var channel_id = player.play_stream(sounds[type], 0, change_volume[type])
	return channel_id

func stop_sound(channel_id: int):
	var player: AudioStreamPlaybackPolyphonic = self.get_stream_playback()
	player.stop_stream(channel_id)


func _on_volume_slider_value_changed(value: float) -> void:
	volume_db = MIN_VOLUME + (MAX_VOLUME - MIN_VOLUME) * (value / 100.0)
	if volume_db == MIN_VOLUME:
		volume_db = -100
