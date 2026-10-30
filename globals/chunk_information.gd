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


const CHUNKS_FILE_PATH := "res://chunks/"

var all_chunks: Array[String] = [
	"res://chunks/chunk_0.tscn", # 0, 0
	"res://chunks/chunk_1.tscn", # -1, 0
	"res://chunks/chunk_2.tscn", # 0, -1
	"res://chunks/chunk_3.tscn", # 1, 0
	"res://chunks/", # -1, -1
	"res://chunks/", # 0, 1
	"res://chunks/", # -2, 0
	"res://chunks/chunk_7.tscn", # 1, -1
	"res://chunks/", # -1, 1
	"res://chunks/", # 0, -2
]
