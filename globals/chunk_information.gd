extends Node

## Chunk size (in metres). Chunks are square, and are based on the x and z length.
const CHUNK_SIZE: float = 16

var chunk_load_radius: int = 5
var chunk_process_radius: int = 1

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
