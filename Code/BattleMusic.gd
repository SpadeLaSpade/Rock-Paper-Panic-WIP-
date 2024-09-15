extends AudioStreamPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	if Globals.difficulty == Globals.difficulties.easy:
		self.set_stream(preload(Globals.easy_theme))
		
	elif Globals.difficulty == Globals.difficulties.normal:
		self.set_stream(preload(Globals.normal_theme))
		
	elif Globals.difficulty == Globals.difficulties.hard:
		self.set_stream(preload(Globals.hard_theme))
		
	self.volume_db = -5 * -Globals.global_audio
	
	if Globals.global_audio <= 0.3:
		self.volume_db = -10
	elif Globals.global_audio <= 0.1:
		self.volume_db = -25


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not self.is_playing() and %Lose.visible == false:
		self.play()
	if %Lose.visible == true:
		self.stop()