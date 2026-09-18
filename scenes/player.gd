extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003

# TOGGLE THIS: Change to true if it feels backwards to your eyes!
@export var invert_y_axis: bool = false

@onready var spring_arm: SpringArm3D = $SpringArm3D

func _ready() -> void:
	# Lock the mouse cursor inside the game window for looking around
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	# Release the mouse cursor when pressing Escape
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif event is InputEventMouseButton and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		
	# Rotate based on mouse movement
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		# Rotate the player body horizontally
		rotate_y(-event.relative.x * mouse_sensitivity)
		
		# Calculate the vertical movement
		var y_rotation = event.relative.y * mouse_sensitivity
		if invert_y_axis:
			y_rotation = -y_rotation
			
		# Apply vertical tilt to the spring arm
		spring_arm.rotate_x(y_rotation)
		
		# Clamp the vertical angle so it cannot flip completely over the head or under the feet
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-60), deg_to_rad(60))
		
		# Keep the camera perfectly straight sideways
		spring_arm.rotation.z = 0
		spring_arm.rotation.y = 0 

func _physics_process(_delta: float) -> void:
	# Get WASD input direction vector
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Calculate world direction based on the player body's horizontal rotation
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, rotation.y).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
