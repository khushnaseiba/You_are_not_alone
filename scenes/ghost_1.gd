extends CharacterBody3D

@export var speed := 3.0
@export var catch_distance := 1.5	

@onready var player = get_tree().current_scene.get_node("player")

var caught := false

func _physics_process(delta):
	if player == null or caught:
		return

	var distance = global_position.distance_to(player.global_position)

	# CAUGHT
	if distance <= catch_distance:
		caught = true
		velocity = Vector3.ZERO

		# Immediately change scene
		get_tree().change_scene_to_file("res://scenes/mainmenu.tscn")
		return

	# FOLLOW PLAYER
	var direction = global_position.direction_to(player.global_position)

	velocity = direction * speed
	move_and_slide()

	# Face player
	look_at(
		Vector3(
			player.global_position.x,
			global_position.y,
			player.global_position.z
		),
		Vector3.UP
	)
