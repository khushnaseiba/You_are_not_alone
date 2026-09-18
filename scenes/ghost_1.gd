extends CharacterBody3D

@export var speed:= 3.0
@export var catch_distance:= 1.8
@export var hear_distance:=30
@onready var sound :AudioStreamPlayer3D=$ghostaudio
var player: Node3D

func _ready() -> void:
	player = get_tree().root.find_child("player", true, false)
	if sound and sound.stream :
		_make_loop(sound.stream)
	print("ghost",player !=null)
func _physics_process(_delta: float) -> void:
	if player == null:
		player = get_tree().root.find_child("player", true, false)
		return

	var to_player := player.global_position - global_position
	to_player.y = 0.0

	if to_player.length() > 0.05:
		var direction := to_player.normalized()
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z))
	else:
		velocity.x = 0.0
		velocity.z = 0.0

	move_and_slide()
	_update_sound()

	if global_position.distance_to(player.global_position) <= catch_distance:
		get_tree().change_scene_to_file("res://scenes/control.tscn")
func _update_sound() -> void:
	if player == null or sound.stream == null or sound == null:
		return
	var distance := global_position.distance_to(player.global_position)
	
	if distance<=hear_distance:
		if not sound.playing:
			sound.play()
		var t := 1.0 - clampf(distance/hear_distance,0.0,1.0)
		sound.volume_db = lerpf(-24.0,10.0,t)
	else:
		if sound.playing:
			sound.stop()
func _make_loop(stream:AudioStream) -> void:
	if stream is AudioStreamWAV:
		stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	elif stream is AudioStreamOggVorbis or AudioStreamMP3:
		stream.loop = true
