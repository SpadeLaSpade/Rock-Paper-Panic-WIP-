extends CanvasLayer

var INITIAL_TIME: int = 10
var time_left: int = INITIAL_TIME
var last_update_time: float = 0.0
var win_tracker:int = -1
var difficulty: String = "unset"
var win_req: int = 0
var timer_min: int = 2

func _ready():
	if Globals.difficulty == Globals.difficulties.normal:
		difficulty = "normal"
		win_req = 10
	elif Globals.difficulty == Globals.difficulties.hard:
		difficulty = "hard"
		win_req = 5
		INITIAL_TIME = 5
	else:
		print("Something has gone seriously wrong, there is no difficulty..")
		win_req = 999
	Globals.generic_telemetry("Difficulty: ",difficulty)
	reset_timer()

func _process(delta: float):
	if !Globals.debug_stoptime:
		last_update_time += delta
		if last_update_time >= 1.0:
			last_update_time -= 1.0
			time_left -= 1
			update_display()
			if time_left <= 0:
				if Globals.debug_autoplay:
					%Player.logic()
				else:
					end_game("lose")

func update_display():
	%Second.text = str(time_left)


func reset_timer():
	time_left = INITIAL_TIME
	last_update_time = 0.0
	update_display()
	%Countdown.visible = true
	# Here we are going to "assume" that they won, as it doesn't reset otherwise anyway..
	win_tracker += 1
	if (win_tracker >= win_req):
		if(INITIAL_TIME > timer_min):
			print("Wins: "+str(win_tracker)+" of: "+str(win_req))
			win_tracker = 0
			INITIAL_TIME -= 1
			print("-1 Second on the timer!")
		# Im cheating!!! Im also applying the option randomizer here MUHAUHAUHA!
		selection_swap()


func selection_swap():
	var objects: Array[TextureButton] = [%Rock, %Paper, %Scissors]
	var objectPos: Array[Vector2] = []
	
	for obj in objects: # Steal all positions
		objectPos.append(obj.global_position)
		print(obj.global_position)
	objectPos.shuffle()
	for i in range(objects.size()): # Swap the positions
		objects[i].global_position = objectPos[i]


func end_game(state: String):
	%Countdown.visible = false
	%Lose.visible = (state == "lose")
	%Countdown.queue_free()
	Globals.generic_telemetry("Final Score: ",str(%Player.score))
