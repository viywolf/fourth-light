@abstract extends RigidBody3D
class_name InteractableObject

@export var is_interactable: bool = true

var object_id: String

var saved_linear_velocity: Vector3
var saved_angular_velocity: Vector3

@abstract func _do_interaction()

func _ready() -> void:
	object_id = str(self)


func _physics_process(delta: float) -> void:
	return
	var global_pos_in_chunks: Vector2 = ChunkInformation.get_position_in_chunks(Vector2(self.global_position.x, self.global_position.y))
	# Put this somewhere else late
	var player_position_in_chunks: Vector2 = ChunkInformation.get_position_in_chunks(Vector2(GameStatus.player.global_position.x, GameStatus.player.global_position.y))
	print(GameStatus.player.global_position)
	print(self.global_position)

	if self.get("linear_velocity") != null:
		# Is the object out of the process zone
		# (Prevents rolling objects from falling out of the map)
		#print(str(global_pos_in_chunks) + " " + str(player_position_in_chunks))
		if (
			(global_pos_in_chunks.x > player_position_in_chunks.x + ChunkInformation.chunk_process_radius / 2.0
				or global_pos_in_chunks.x < player_position_in_chunks.x - ChunkInformation.chunk_process_radius / 2.0)
			or 
			(global_pos_in_chunks.y > player_position_in_chunks.y + ChunkInformation.chunk_process_radius / 2.0 
			or global_pos_in_chunks.y < player_position_in_chunks.y - ChunkInformation.chunk_process_radius / 2.0) 
			):
			set_rigid_body_velocity(false)
			print("AFSOJSFL")
		else:
			set_rigid_body_velocity(true)


func set_rigid_body_velocity(on: bool) -> void:
	if on:
		self.angular_velocity = saved_angular_velocity
		self.linear_velocity = saved_linear_velocity
	else:
		saved_angular_velocity = self.angular_velocity
		self.angular_velocity = Vector3.ZERO
		saved_linear_velocity = self.linear_velocity
		self.linear_velocity = Vector3.ZERO
	
