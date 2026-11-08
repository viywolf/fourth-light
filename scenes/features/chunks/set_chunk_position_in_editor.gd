@tool
extends Node

@export var node_to_change: Node3D
@export var chunk_number: int
@export var set_node_position: bool = false

@export var search_radius: int = 10

func _process(_delta: float) -> void:
	if set_node_position == true:
		set_node_position = false
		var chunk_position: Vector2i = get_chunk_coords(chunk_number)
		node_to_change.position = Vector3(chunk_position.x * ChunkInformation.CHUNK_SIZE, 0, chunk_position.y * ChunkInformation.CHUNK_SIZE)
		node_to_change.position.x += ChunkInformation.CHUNK_SIZE / 2
		node_to_change.position.z += ChunkInformation.CHUNK_SIZE / 2
		

## Brute force search to find the corresponding coords for a number
# There's a formula for this somewhere?
func get_chunk_coords(target: int) -> Vector2i:
	var i: int = 0
	var j: int = 0
	var diff := Vector2i(0, -1)
	
	for _i in range(pow(search_radius + 1, 2)):
		if (i > -search_radius / 2.0 and
				i <= search_radius / 2.0 and
				j > -search_radius / 2.0 and
				j <= search_radius / 2.0):
			if ChunkInformation.get_cantor_int_from_pair(Vector2i(i, j)) == target:
				return Vector2i(i, j) 
		if (i == j or
			(i < 0 and i == -j) or
			(i > 0 and i == 1 - j)):
				diff = Vector2(-diff.y, diff.x)
		i += diff.x
		j += diff.y
		
	printerr("Chunk coords of " + str(target) + " was not found, expand search radius.")
	return Vector2i.ZERO
