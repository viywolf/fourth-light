extends Control


func _ready() -> void:
	# Chunks
	%LoadContainer/Label.text = "Load Distance: " + str(ChunkInformation.chunk_load_radius)
	%ProcessContainer/Label.text = "Load Distance: " + str(ChunkInformation.chunk_process_radius)
	%FPSContainer/Label.text = "Frames Per Second: " + str(Settings.frames_per_second)



func _on_load_h_slider_value_changed(value: float) -> void:
	var int_value = int(value)
	ChunkInformation.chunk_load_radius = int_value
	%LoadContainer/Label.text = "Load Distance: " + str(int_value)
	


func _on_process_h_slider_value_changed(value: float) -> void:
	var int_value = int(value)
	ChunkInformation.chunk_load_radius = int_value
	%ProcessContainer/Label.text = "Load Distance: " + str(int_value)


func _on_button_12_pressed() -> void:
	Settings.update_fps(12)
	%FPSContainer/Label.text = "Frames Per Second (12)"


func _on_button_30_pressed() -> void:
	Settings.update_fps(30)
	%FPSContainer/Label.text = "Frames Per Second (30)"


func _on_button_60_pressed() -> void:
	Settings.update_fps(60)
	%FPSContainer/Label.text = "Frames Per Second (60)"
