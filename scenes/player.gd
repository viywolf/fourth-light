extends CharacterBody3D

var movement_direction: Vector3
var camera_direction: Vector3

var raw_input: Vector2

var speed: float = 8
var jump_velocity: float = 25

var rotation_speed: float = 12

var last_move_direction: Vector3 = Vector3.BACK

var jumps_left: int = 1
var coyote_timer: float = 0

# Move this elsewhere to easier change it
var gravity: float = 70

var acceleration: float = 50
var deceleration: float = 50

var is_gliding := false

var max_glide_speed: float = 30
var starting_glide_speed: float = 20
var glide_speed: float = 10
var glide_speed_y: float
var glide_speed_retainment_rate: float = 0.05
var glide_turning_speed_decrease: float = 8

var yaw_difference: float = 0
var previous_yaw: float = 0

var is_swimming := false

var swim_speed: float = 10
var swim_acceleration: float = 6
var swim_deceleration: float = 8
var swim_rise_speed: float = 0.2

func _physics_process(delta: float) -> void:
	# Get basic inputs
	raw_input = Input.get_vector("left", "right", "forward", "backward")
	var local_forward: Vector3 = %Camera.global_basis.z
	var local_right: Vector3 = %Camera.global_basis.x
	
	camera_direction = -%Camera.global_basis.z
	movement_direction = (local_forward * raw_input.y) + (local_right * raw_input.x)
	yaw_difference = previous_yaw - self.rotation.y
	
	# Swimming
	
	for node in get_tree().get_nodes_in_group("Water"):
		if node.get_node("Area3D").overlaps_body(self):
			is_swimming = true
			stop_gliding()
		else:
			is_swimming = false
	
	# Gliding
	
	if Input.is_action_just_pressed("glide"):
		is_gliding = !is_gliding
		if is_gliding == true:
			$GliderModel.show()
		else:
			stop_gliding()
		glide_speed = starting_glide_speed
		glide_speed_y = 0
	
	
	if is_swimming:
		swim_movement(delta)
	elif is_gliding:
		glide_movement(delta)
	else:
		ground_movement(delta)


func ground_movement(delta: float) -> void:
	movement_direction.y = 0.0
	movement_direction = movement_direction.normalized()
	if raw_input != Vector2.ZERO:
		self.velocity = velocity.move_toward(movement_direction * speed, acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector3.ZERO, deceleration * delta)
	
	if is_on_floor() == false:
		self.velocity.y = move_toward(self.velocity.y, -gravity, gravity * delta)
		coyote_timer -= delta
	else:
		coyote_timer = 1
		jumps_left = 1
		
	var is_starting_jump: bool = Input.is_action_just_pressed("jump") and coyote_timer > 0 and jumps_left > 0
	
	if is_starting_jump:
		self.velocity.y = jump_velocity
		jumps_left -= 1
		
	previous_yaw = self.rotation.y
		
	move_and_slide()
	
	if movement_direction.length() > 0.2:
		last_move_direction = movement_direction
	var target_angle: float = Vector3.BACK.signed_angle_to(last_move_direction, Vector3.UP)
	self.global_rotation.y = lerp_angle(self.global_rotation.y, target_angle, rotation_speed * delta)
	

func glide_movement(delta: float) -> void:
	if is_on_floor():
		stop_gliding()
	
	self.rotation.y = camera_direction.x
	
	var face_direction_up = Vector3.UP.dot(camera_direction)
	if face_direction_up > 0: #Looking above the horizon
		glide_speed = move_toward(glide_speed, 0, gravity * delta * glide_speed_retainment_rate * face_direction_up)
		glide_speed_y = move_toward(glide_speed_y, -gravity, gravity * delta * glide_speed_retainment_rate * face_direction_up)
	else:
		glide_speed += Vector3.DOWN.dot(camera_direction) * delta * speed * glide_speed_retainment_rate
		if glide_speed > 2:
			glide_speed_y = 0
		else:
			glide_speed_y -= gravity * delta
		
	glide_speed -= yaw_difference * delta * glide_turning_speed_decrease
	
	glide_speed = clampf(glide_speed, 0, max_glide_speed)
	if glide_speed < 2:
		glide_speed_y -= gravity * delta
	
	self.velocity = velocity.move_toward(camera_direction * glide_speed, acceleration * delta)
	self.velocity.y += glide_speed_y / 5
	
	if false:
		print("Velocity y: " + str(velocity.y))
		print("Glide speed: " + str(glide_speed))
	
	if is_equal_approx(self.velocity.y, -gravity):
		stop_gliding()
	move_and_slide()
	
	
func swim_movement(delta: float) -> void:
	movement_direction = movement_direction.normalized()
	if raw_input != Vector2.ZERO:
		self.velocity = velocity.move_toward(movement_direction * swim_speed, swim_acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector3.ZERO, swim_deceleration * delta)
	
	if Input.is_action_pressed("jump"):
		self.velocity.y += swim_rise_speed
		
	move_and_slide()


func stop_gliding() -> void:
	is_gliding = false
	$GliderModel.hide()
