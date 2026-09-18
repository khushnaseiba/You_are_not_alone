extends AudioStreamPlayer3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void: 
	
	if stream:
		stream.loop = true
	if not playing:
		play()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
