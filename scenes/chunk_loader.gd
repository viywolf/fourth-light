extends Node3D

var chunk: Node3D

# Move this to the player script with a signal going up?
var player_pos: Vector2
var prev_player_pos: Vector2

func _ready() -> void:
	chunk = Node3D.new()
	var label := Label3D.new()
	label.font_size = 200
	label.rotation_degrees.x = -90
	label.position.y = 1
	chunk.add_child(label)
	var mesh := MeshInstance3D.new()
	var plane_mesh := PlaneMesh.new()
	plane_mesh.size = Vector2(16, 16)
	mesh.mesh = plane_mesh
	chunk.add_child(mesh)
	var static_body := StaticBody3D.new()
	var coll_shape := CollisionShape3D.new()
	var box_shape := BoxShape3D.new()
	box_shape.size = Vector3(16, 2, 16)
	coll_shape.shape = box_shape
	coll_shape.position.y = -1
	static_body.add_child(coll_shape)
	chunk.add_child(static_body)


func _physics_process(delta: float) -> void:
	player_pos = Vector2(%Player.global_position.x, %Player.global_position.z)
	if get_position_in_chunks(player_pos) != get_position_in_chunks(prev_player_pos):
		load_chunks(get_position_in_chunks(player_pos), ChunkInformation.chunk_load_radius)
	prev_player_pos = player_pos
	$GUI/Label2.text = str(get_position_in_chunks(player_pos))


func get_cantor_int_from_pair(pair: Vector2i) -> int:
	var x: int = pair.x
	var y: int = pair.y
	# Convert int to natural numbers
	if x >= 0:
		x = 2 * x
	else:
		x = (-2 * x) - 1
	if y >= 0:
		y = 2 * y
	else:
		y = (-2 * y) - 1
	# Cantor pairing formula
	return int(0.5 * (x + y) * (x + y + 1)) + y


func get_position_in_chunks(input_position: Vector2) -> Vector2:
	return floor(input_position / ChunkInformation.CHUNK_SIZE)


func get_coords_from_chunks(chunk_input: Vector2) -> Vector3:
	return Vector3(chunk_input.x * ChunkInformation.CHUNK_SIZE, 0, chunk_input.y * ChunkInformation.CHUNK_SIZE)


func add_chunk(chunk_id: Vector2i) -> void:
	var new_chunk: Node3D = chunk.duplicate()
	new_chunk.position = get_coords_from_chunks(chunk_id)
	new_chunk.position.x += ChunkInformation.CHUNK_SIZE / 2
	new_chunk.position.z += ChunkInformation.CHUNK_SIZE / 2
	new_chunk.get_child(0).text = str(chunk_id) + "\n" + str(get_cantor_int_from_pair(chunk_id))
	new_chunk.name = str(get_cantor_int_from_pair(chunk_id))
	
	$World.add_child(new_chunk)

func load_chunks(center_position: Vector2, chunk_radius: int) -> void:
	
	var checked_chunks: Dictionary[int, bool]
	
	for child in $World.get_children():
		checked_chunks[int(child.name)] = false
	
	for i in range(-(chunk_radius - 1), chunk_radius):
		for j in range(-(chunk_radius - 1), chunk_radius):
			var cur_pos := Vector2i(i + center_position.x, j + center_position.y)
			if get_node_or_null("World/" + str(get_cantor_int_from_pair(cur_pos))) == null:
				add_chunk(cur_pos)
			checked_chunks[get_cantor_int_from_pair(cur_pos)] = true
			print(str(cur_pos) + ": " + str(get_cantor_int_from_pair(cur_pos)))
			
	for key in checked_chunks.keys():
		if checked_chunks[key] == false:
			$World.get_node(str(key)).queue_free()
	
