extends Node

## Chunk size (in metres). Chunks are square, and are based on the x and z length.
const CHUNK_SIZE: float = 16

var only_load_new_chunks: bool = true
var chunk_load_radius: int = 8
var chunk_process_radius: int = 5

"""
Chunk order

	   9
	4  2  7
 6  1  0  3
	8  5  


"""


const CHUNKS_FILE_PATH := "res://scenes/chunks/"
const NO_OF_READY_CHUNKS: int = 10

var all_chunks: Array[String]

func _ready() -> void:
	for i in range(NO_OF_READY_CHUNKS):
		all_chunks.append(CHUNKS_FILE_PATH + "chunk_" + str(i) + ".tscn")


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
