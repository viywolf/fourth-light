extends Node

const SAVE_FILE_PATH = "user://save_file.json"

func save_game() -> void:
	print("Saving game")
	
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("saveables")
	
	for node: Node in save_nodes:
		if node.has_method("save"):
			var node_data = node.call("save")
			var json_string = JSON.stringify(node_data)
			save_file.store_line(json_string)
		else:
			printerr("Node " + str(node) + " in saveables group does not have save() method")
			
			

func load_game() -> void:
	pass
	
	
func get_save_data(scene_path: String = "") -> Dictionary:
	var save_data: Dictionary
	
	if FileAccess.file_exists(SAVE_FILE_PATH) == false:
		print("No save file exists")
		return {}
		
	var save_file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string: String = save_file.get_line()
		var json := JSON.new()
		
		var parse_result: Error = json.parse(json_string)
		if not parse_result == OK:
			printerr("JSON parse error: " + str(json.get_error_message()) + " at line " + str(json.get_error_line()))
			continue
			
		var node_data: Dictionary = json.data
		
		# If the data corresponding to the scene path has been found
		if node_data.has("filename") and node_data.get("filename") == scene_path:
			return node_data
		
		print(node_data)
		
	return save_data
