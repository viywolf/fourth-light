extends Node


var frames_per_second: int = 60

func update_fps(new_fps: int) -> void:
	frames_per_second = new_fps
	Engine.max_fps = frames_per_second
	

enum{
	MAIN_VOLUME,
	MUSIC_VOLUME,
	SFX_VOLUME
}

var main_volume: float

func update_volume(volume_type: int, volume_in_percentage: float) -> void:
	match volume_type:
		MAIN_VOLUME:
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), volume_in_percentage)
		MUSIC_VOLUME:
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), volume_in_percentage)
		SFX_VOLUME:
			AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), volume_in_percentage)

func get_volume(volume_type: int) -> float:
	match volume_type:
		MAIN_VOLUME:
			return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Master"))
		MUSIC_VOLUME:
			return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("Music"))
		SFX_VOLUME:
			return AudioServer.get_bus_volume_linear(AudioServer.get_bus_index("SFX"))
		_:
			printerr("Get volume invalid volume type")
			return -1
