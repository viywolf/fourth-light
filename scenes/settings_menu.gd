extends Control


func _ready() -> void:
	# Chunks
	%LoadContainer/Label.text = "Load Distance: " + str(ChunkInformation.chunk_load_radius)
	%LoadContainer/LoadHSlider.value = ChunkInformation.chunk_load_radius
	%ProcessContainer/Label.text = "Process Distance: " + str(ChunkInformation.chunk_process_radius)
	%ProcessContainer/ProcessHSlider.value = ChunkInformation.chunk_process_radius
	
	%FPSContainer/Label.text = "Frames Per Second (" + str(Settings.frames_per_second) + ")"
	
	# Volume
	%MainVolumeContainer/Label.text = "Main Volume: " + str(Settings.get_volume(Settings.MAIN_VOLUME))
	%MainVolumeContainer/MainHSlider.value = Settings.get_volume(Settings.MAIN_VOLUME)
	%MusicVolumeContainer/Label.text = "Music Volume: " + str(Settings.get_volume(Settings.MUSIC_VOLUME))
	%MusicVolumeContainer/MusicHSlider.value = Settings.get_volume(Settings.MUSIC_VOLUME)
	%SFXVolumeContainer/Label.text = "SFX Volume: " + str(Settings.get_volume(Settings.SFX_VOLUME))
	%SFXVolumeContainer/SFXHSlider.value = Settings.get_volume(Settings.SFX_VOLUME)


func to_percentage(number: float) -> String:
	return str(int(round(number * 100))) + "%"


func _on_load_h_slider_value_changed(value: float) -> void:
	var int_value = int(value)
	ChunkInformation.chunk_load_radius = int_value
	%LoadContainer/Label.text = "Load Distance: " + str(int_value)
	


func _on_process_h_slider_value_changed(value: float) -> void:
	var int_value = int(value)
	ChunkInformation.chunk_process_radius = int_value
	%ProcessContainer/Label.text = "Process Distance: " + str(int_value)


# FPS

func _on_button_12_pressed() -> void:
	Settings.update_fps(12)
	%FPSContainer/Label.text = "Frames Per Second (12)"


func _on_button_30_pressed() -> void:
	Settings.update_fps(30)
	%FPSContainer/Label.text = "Frames Per Second (30)"


func _on_button_60_pressed() -> void:
	Settings.update_fps(60)
	%FPSContainer/Label.text = "Frames Per Second (60)"


# Volume


func _on_main_h_slider_value_changed(value: float) -> void:
	Settings.update_volume(Settings.MAIN_VOLUME, value)
	%MainVolumeContainer/Label.text = "Main Volume: " + to_percentage(Settings.get_volume(Settings.MAIN_VOLUME))

func _on_music_h_slider_value_changed(value: float) -> void:
	Settings.update_volume(Settings.MUSIC_VOLUME, value)
	%MusicVolumeContainer/Label.text = "Music Volume: " + to_percentage(Settings.get_volume(Settings.MUSIC_VOLUME))


func _on_sfxh_slider_value_changed(value: float) -> void:
	Settings.update_volume(Settings.SFX_VOLUME, value)
	%SFXVolumeContainer/Label.text = "SFX Volume: " + to_percentage(Settings.get_volume(Settings.SFX_VOLUME))




func _on_close_button_pressed() -> void:
	queue_free()
