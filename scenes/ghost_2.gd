extends CharacterBody3D
@export var speed : float = 10.0
@export var player_path: NodePath
@onready var catch_area :Area3D =$catcharea
var player : Node3D 
func _ready() -> void:
	if not player_path.is_empty():
		player = get_node(player_path)
	else:
		player = get_tree().get_first_node_in_group("player")
		catch_area.body_enter
		
func _physics_process(delta: float) -> void:
	if player :
		var target_pos = player.global_position
		var direction = global_position.direction_to(target_pos)
		
		velocity = direction*speed
		if direction.length_squared()>0.001:
			var look_target = Vector3(target_pos.x, global_position.y, target_pos.z)
			if global_position.distance_to(look_target)>0.1:
				look_at(look_target,Vector3.UP)
		move_and_slide()
		

		
