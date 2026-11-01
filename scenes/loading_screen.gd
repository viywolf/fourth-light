extends CanvasLayer

var scene_to_load_path: String = "res://scenes/chunk_loading_test.tscn"

var load_wait_count: float = 0

var min_wait_count: float = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ResourceLoader.load_threaded_request(scene_to_load_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	load_wait_count += delta * 2
	$LoadingLabel.text = "Loading"
	for i in range(int(load_wait_count) % 4):
		$LoadingLabel.text += "."
	var progress: Array[float]
	ResourceLoader.load_threaded_get_status(scene_to_load_path, progress) 
	if is_equal_approx(progress[0], 1.0) and load_wait_count > min_wait_count:
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(scene_to_load_path))
		queue_free()
