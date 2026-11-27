@abstract extends RigidBody3D
class_name InteractableObject

@export var is_interactable: bool = true

@export var object_type: String

var object_id: String

var is_object_velocity_disabled: bool = false

var saved_linear_velocity: Vector3
var saved_angular_velocity: Vector3

@abstract func do_interaction() -> bool

func _ready() -> void:
	object_id = str(self)
	if object_type == "":
		printerr("Object " + str(self) + " has no object type")


func _physics_process(_delta: float) -> void:
	
	var global_pos_in_chunks: Vector2 = ChunkInformation.get_position_in_chunks(Vector2(self.global_position.x, self.global_position.z))
	var player_position_in_chunks: Vector2 = ChunkInformation.get_player_position_in_chunks()

	# If the object is out of the process zone, disable it
	# (Prevents rolling objects from falling out of the map)
	if (
		(global_pos_in_chunks.x > player_position_in_chunks.x + ChunkInformation.chunk_process_radius / 2.0
			or global_pos_in_chunks.x < player_position_in_chunks.x - ChunkInformation.chunk_process_radius / 2.0)
		or 
		(global_pos_in_chunks.y > player_position_in_chunks.y + ChunkInformation.chunk_process_radius / 2.0 
		or global_pos_in_chunks.y < player_position_in_chunks.y - ChunkInformation.chunk_process_radius / 2.0) 
		):
		set_rigid_body_velocity(false)
	else:
		pass
		set_rigid_body_velocity(true)

## Saves and clears angular/linear velocity or sets it
func set_rigid_body_velocity(on: bool) -> void:
	if is_object_velocity_disabled == on:
		return
	is_object_velocity_disabled = on
	if on:
		self.angular_velocity = saved_angular_velocity
		self.linear_velocity = saved_linear_velocity
	else:
		
		print("out of process zone")
		saved_angular_velocity = self.angular_velocity
		self.angular_velocity = Vector3.ZERO
		saved_linear_velocity = self.linear_velocity
		self.linear_velocity = Vector3.ZERO
	
