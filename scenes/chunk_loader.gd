extends Node3D

var chunk: Node3D

func _ready() -> void:
	chunk = Node3D.new()
	var label := Label3D.new()
	label.font_size = 200
	label.rotation_degrees.x = -90
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
	
	##
	
	for i in range(5):
		for j in range(5):
			add_chunk(Vector2i(i, j))
	


func _process(delta: float) -> void:
	var player_pos: Vector2 = Vector2(%Player.global_position.x, %Player.global_position.z)
	$GUI/Label2.text = str(get_position_in_chunks(player_pos))
	#print(get_position_in_chunks())


func get_position_in_chunks(input_position: Vector2) -> Vector2:
	# Replace the player with a variable from save or something
	#
	
	return floor(input_position / ChunkInformation.CHUNK_SIZE)


func get_coords_from_chunks(chunk_input: Vector2) -> Vector3:
	return Vector3(chunk_input.x * ChunkInformation.CHUNK_SIZE, 0, chunk_input.y * ChunkInformation.CHUNK_SIZE)


func add_chunk(chunk_id: Vector2i):
	var new_chunk: Node3D = chunk.duplicate()
	new_chunk.position = get_coords_from_chunks(chunk_id)
	new_chunk.position.x += ChunkInformation.CHUNK_SIZE / 2
	new_chunk.position.z += ChunkInformation.CHUNK_SIZE / 2
	new_chunk.get_child(0).text = str(chunk_id)
	$World.add_child(new_chunk)
