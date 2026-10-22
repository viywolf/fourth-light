extends CharacterBody3D

var movement_direction: Vector3
var camera_direction: Vector3

var raw_input: Vector2

var speed: float = 8
var jump_velocity: float = 35

var rotation_speed: float = 12

var last_move_direction: Vector3 = Vector3.BACK

var jumps_left: int = 1

var jump_timer: float = 0
var jump_cooldown: float = 0.1

var coyote_timer: float = 0
var coyote_time: float = 0.15

var gravity: float = 110

var acceleration: float = 25
var deceleration: float = 50

var is_gliding := false

var glide_max_speed: float = 35
var glide_starting_speed: float = 5
var glide_speed: float = 10
var glide_speed_y: float = 0
var glide_speed_retainment_rate: float = 0.25
var glide_turning_speed_decrease: float = 150
var glide_gravity: float = 10

var yaw_difference: float = 0
var previous_yaw: float = 0

var is_swimming := false
var is_underwater := false

var is_head_under_water := false
var bob_velocity: float = 5

var is_diving := false
var dive_timer: float = 0
var dive_time: float = 2
var dive_speed: float = 5

var swim_speed: float = 10
var swim_acceleration: float = 6
var swim_deceleration: float = 8
var swim_rise_speed: float = 0.2
var swim_sink_speed: float = 0.2
var swim_max_vertical_speed: float = 10

func _physics_process(delta: float) -> void:
	# Get basic inputs
	raw_input = Input.get_vector("left", "right", "forward", "backward")
	var local_forward: Vector3 = %Camera.global_basis.z
	var local_right: Vector3 = %Camera.global_basis.x
	
	camera_direction = -%Camera.global_basis.z
	movement_direction = (local_forward * raw_input.y) + (local_right * raw_input.x)
	yaw_difference = previous_yaw - self.rotation.y
	previous_yaw = self.rotation.y
	
	# Gliding
	
	if Input.is_action_just_pressed("movement_ability"):
		is_gliding = !is_gliding
		if is_gliding == true:
			$GliderModel.show()
		else:
			stop_gliding()
		glide_speed = glide_starting_speed
		glide_speed_y = 0
		
		
	# Swimming
	
	for node in get_tree().get_nodes_in_group("Water"):
		if node.get_node("Area3D").overlaps_body(self):
			is_swimming = true
			stop_gliding()
		else:
			is_swimming = false
			
		if node.get_node("Area3D").overlaps_body($HeadPosition):
			is_head_under_water = true
		else:
			is_head_under_water = false
			
	if Input.is_action_just_pressed("movement_ability") and is_swimming:
		is_diving = true
		
	
	if is_diving:
		dive_timer = dive_time
		dive_into_water(delta)
		swim_movement(delta)
	elif is_swimming:
		stay_above_water(delta)
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
		coyote_timer = coyote_time
		jumps_left = 1
		jump_timer -= delta
		
	var is_starting_jump: bool = (
		Input.is_action_pressed("jump") 
		and coyote_timer > 0
		and jumps_left > 0
		and jump_timer <= 0
		)
	
	if is_starting_jump:
		self.velocity.y = jump_velocity
		jumps_left -= 1
		jump_timer = jump_cooldown
		
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
	var face_direction_down = Vector3.DOWN.dot(camera_direction)
	if face_direction_up > 0: #Looking above the horizon
		# Glide speed decreases towards 0
		var glide_speed_diff: float = glide_speed - move_toward(glide_speed, 0, gravity * delta * glide_speed_retainment_rate * face_direction_up)
		glide_speed = move_toward(glide_speed, 0, gravity * delta * glide_speed_retainment_rate * face_direction_up)
		glide_speed_y -= glide_speed_diff / glide_speed_retainment_rate * delta
	else:
		# Glide speed increases based on how much it is facing down (0 to 1)
		glide_speed += face_direction_down * delta * (glide_max_speed)
		if glide_speed > 2:
			glide_speed_y = move_toward(glide_speed_y, 0, gravity * delta * glide_speed_retainment_rate)
		else:
			glide_speed_y -= gravity * delta * glide_speed_retainment_rate
		
	#glide_speed -= abs(yaw_difference * delta * glide_turning_speed_decrease)
	
	glide_speed = clampf(glide_speed, 0, glide_max_speed)
	if glide_speed < 2:
		glide_speed_y -= glide_gravity * delta
		glide_speed_y = clampf(glide_speed_y, -glide_gravity, glide_speed_y)
	
	self.velocity = velocity.move_toward(camera_direction * glide_speed, acceleration * delta)
	self.velocity.y += glide_speed_y / 5
	self.velocity.y = clampf(self.velocity.y, -glide_gravity, self.velocity.y)
		
	%GlideLabel.text = "Glide Speed: " + str(round(glide_speed))
	%HeightLabel.text = "Height: " + str(round(self.global_position.y))
	
	if is_equal_approx(self.velocity.y, -gravity):
		stop_gliding()
	move_and_slide()
	
	
func stop_gliding() -> void:
	is_gliding = false
	$GliderModel.hide()


func stay_above_water(delta: float) -> void:
	if is_head_under_water:
		self.velocity.y -= bob_velocity * delta


func dive_into_water(delta: float) -> void:
	self.velocity.y = dive_speed
	dive_timer -= delta
	if dive_timer <= 0:
		is_diving = false

	
func swim_movement(delta: float) -> void:
	movement_direction = movement_direction.normalized()
	if raw_input != Vector2.ZERO:
		self.velocity = velocity.move_toward(movement_direction * swim_speed, swim_acceleration * delta)
	else:
		self.velocity = velocity.move_toward(Vector3.ZERO, swim_deceleration * delta)
	
	if Input.is_action_pressed("jump"):
		self.velocity.y += swim_rise_speed
	elif Input.is_action_pressed("shift"):
		self.velocity.y -= swim_sink_speed
		
	self.velocity.y = clampf(self.velocity.y, -swim_max_vertical_speed, swim_max_vertical_speed)
		
	move_and_slide()
