extends Node

enum{
	MAIN_VOLUME,
	MUSIC_VOLUME,
	SFX_VOLUME
}

var frames_per_second: int = 60

var autosave_time: float = 3

func update_fps(new_fps: int) -> void:
	frames_per_second = new_fps
	Engine.max_fps = frames_per_second


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



func save() -> Dictionary:
	return {
		"filename": self.scene_file_path,
		"main_volume": get_volume(MAIN_VOLUME),
		"music_volume": get_volume(MUSIC_VOLUME),
		"sfx_volume": get_volume(SFX_VOLUME),
		"fps": self.frames_per_second,
		"chunk_load_radius": ChunkInformation.chunk_load_radius,
		"chunk_process_radius": ChunkInformation.chunk_process_radius,
		"chunk_only_load_new": ChunkInformation.only_load_new_chunks,
	}


func load_data() -> void:
	var data: Dictionary = SaveFile.get_save_data(self.scene_file_path)
	for key in data.keys():
		match key:
			"main_volume":
				update_volume(MAIN_VOLUME, data[key])
			"music_volume":
				update_volume(MUSIC_VOLUME, data[key])
			"sfx_volume":
				update_volume(SFX_VOLUME, data[key])
			"fps":
				update_fps(data[key])
			"chunk_load_radius": 
				ChunkInformation.chunk_load_radius = data[key]
			"chunk_process_radius": 
				ChunkInformation.chunk_process_radius = data[key]
			"chunk_only_load_new": 
				ChunkInformation.only_load_new_chunks = data[key]
