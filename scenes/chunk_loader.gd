extends Node3D

var chunk: Node3D

# Move this to the player script with a signal going up?
var player_pos: Vector2
var prev_player_pos: Vector2 

var checked_chunks: Dictionary[int, bool]

# Loading async vars
var is_cancelling_loading: bool = false

var only_load_new_chunks: bool = true

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
	add_chunk(Vector2i(0, 0))
	
	$ChunksPlaceholder.queue_free()
	
	load_chunks(get_position_in_chunks(player_pos), ChunkInformation.chunk_load_radius)
	


func _physics_process(_delta: float) -> void:
	player_pos = Vector2(%Player.global_position.x, %Player.global_position.z)
	if get_position_in_chunks(player_pos) != get_position_in_chunks(prev_player_pos):
		add_chunk(get_position_in_chunks(player_pos))
		load_chunks(get_position_in_chunks(player_pos), ChunkInformation.chunk_load_radius)
	prev_player_pos = player_pos
	
	%PlayerChunkPosLabel.text = str(get_position_in_chunks(player_pos))
	%ChunkLoadDistLabel.text = "Chunk Loading Distance: " + str(ChunkInformation.chunk_load_radius)
	%OnlyLoadNewChunksLabel.text = "Only Load New Chunks: " + str(only_load_new_chunks)


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
	var new_chunk: Node3D
	if get_cantor_int_from_pair(chunk_id) <  ChunkInformation.all_chunks.size() \
		and FileAccess.file_exists(ChunkInformation.all_chunks[get_cantor_int_from_pair(chunk_id)]):
			new_chunk = load(ChunkInformation.all_chunks[get_cantor_int_from_pair(chunk_id)]).instantiate()
	else:
		new_chunk = chunk.duplicate()
		new_chunk.get_child(0).text = str(chunk_id) + "\n" + str(get_cantor_int_from_pair(chunk_id))
		#print(new_chunk.get_child(0).text)
		
	new_chunk.position = get_coords_from_chunks(chunk_id)
	new_chunk.position.x += ChunkInformation.CHUNK_SIZE / 2
	new_chunk.position.z += ChunkInformation.CHUNK_SIZE / 2
	
	await get_tree().physics_frame
	
	if $World.get_node_or_null(str(get_cantor_int_from_pair(chunk_id))) == null:
		new_chunk.name = str(get_cantor_int_from_pair(chunk_id))
		$World.add_child(new_chunk)

func load_chunks(center_position: Vector2, chunk_radius: int) -> void:
	is_cancelling_loading = true
	# Hopefully there is enough time to
	# cancel other async loads by the time this is false
	
	for child in $World.get_children():
		checked_chunks[int(child.name)] = false
			
	
	if only_load_new_chunks == false:
		for child in $World.get_children():
			child.queue_free()
			
			
	await get_tree().create_timer(0.1).timeout
			
	is_cancelling_loading = false
	
	# Loop through all chunks in a spiral
	var i: int = 0
	var j: int = 0
	var diff := Vector2i(0, -1)
	
	for _i in range(pow(chunk_radius + 1, 2)):
		if (i > -chunk_radius / 2.0 and
			i <= chunk_radius / 2.0 and
			j > -chunk_radius / 2.0 and
			j <= chunk_radius / 2.0):
				var cur_pos := Vector2(i + center_position.x, j + center_position.y)
				checked_chunks[get_cantor_int_from_pair(cur_pos)] = true
				if get_node_or_null("World/" + str(get_cantor_int_from_pair(cur_pos))) == null:
					await add_chunk(cur_pos)
					if is_cancelling_loading:
						is_cancelling_loading = false
						break
				else:
					$World.get_node(str(get_cantor_int_from_pair(cur_pos))).process_mode = Node.PROCESS_MODE_INHERIT
		if (i == j or
			(i < 0 and i == -j) or
			(i > 0 and i == 1 - j)):
				diff = Vector2(-diff.y, diff.x)
		i += diff.x
		j += diff.y
	
	
	# Remove chunks that have not been loaded in the main loader loop
	for key in checked_chunks.keys():
		# If it was not checked this loop
		if checked_chunks[key] == false:
			# and it exists
			if $World.get_node_or_null(str(key)) != null:
				#$World.get_node(str(key)).queue_free()
				$World.get_node(str(key)).process_mode = Node.PROCESS_MODE_DISABLED
			else:
				print("tried to remove " + str(key) + " but it didnt exist")
	
