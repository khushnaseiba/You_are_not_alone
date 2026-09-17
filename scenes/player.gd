extends CharacterBody3D

@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var mouse_sensitivity: float = 0.003

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
		
	# Rotate the camera stick based on mouse movement
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		spring_arm.rotate_y(-event.relative.x * mouse_sensitivity)
		spring_arm.rotate_x(-event.relative.y * mouse_sensitivity)
		# Limit vertical camera angles so it doesn't flip completely upside down
		spring_arm.rotation.x = clamp(spring_arm.rotation.x, deg_to_rad(-60), deg_to_rad(30))

func _physics_process(delta: float) -> void:
	# Apply engine gravity if the player is in the air
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle Jump (using Spacebar by default)
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity

	# Get WASD input direction vector
	var input_dir := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	# Calculate world direction based on the horizontal angle of the spring arm
	var direction := (Vector3(input_dir.x, 0, input_dir.y)).rotated(Vector3.UP, spring_arm.rotation.y).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
