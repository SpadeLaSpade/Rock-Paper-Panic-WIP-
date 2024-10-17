extends Node2D

var score: int = 0
var pressed_timer: Timer
var can_press: bool = true

func _ready() -> void:
	%Factory_Background.play("default")
	score = 0
	update_score()
	pressed_timer = Timer.new()
	pressed_timer.set_wait_time(0.5)
	pressed_timer.one_shot = true
	add_child(pressed_timer)
	pressed_timer.connect("timeout", Callable(self,"update_selection_images"))

func visual_pressed(button: String):
	if button == "Rock":
		%Rock.play("press",true)
	elif button == "Paper":
		%Paper.play("press")
	elif button == "Scissors":
		%Scissors.play("press")
	elif button == "Lizard":
		%Lizard.play("press")
	elif button == "Hunter":
		%Hunter.play("press")
	
	pressed_timer.start()

func logic(choice: String = ""):
	if !can_press:
		return
	visual_pressed(choice)

	var outcomes = {
		"Rock": ["Scissors", "Lizard"],
		"Scissors": ["Paper", "Lizard"],
		"Paper": ["Rock", "Hunter"],
		"Lizard": ["Hunter", "Paper"],
		"Hunter": ["Scissors", "Rock"]
	}

	var enemy_choice = %Enemy.choice

	if choice != "":
		if choice in outcomes and enemy_choice in outcomes[choice]:
			score += 1
			%Enemy.new_choice()
			%Countdown.reset_timer()
		elif enemy_choice in outcomes and choice in outcomes[enemy_choice]:
			%Countdown.end_game("lose")
	else:
		score += 1
		%Enemy.new_choice()
		%Countdown.reset_timer()

	update_score()

func update_score():
	%Score.text = str(score)
	%Final_Score.text = "FINAL SCORE: \n" + str(score)

func retry():
	get_tree().reload_current_scene()

func _on_main_menu_pressed():
	Globals.set_scene("res://Scenes/mainmenu.tscn")

func _on_quit_pressed():
	Globals.quit()

func _on_rock_trigger_pressed() -> void:
	logic("Rock")

func _on_paper_trigger_pressed() -> void:
	logic("Paper")

func _on_scissors_trigger_pressed() -> void:
	logic("Scissors")

func _on_hunter_trigger_pressed() -> void:
	logic("Hunter")

func _on_lizard_trigger_pressed() -> void:
	logic("Lizard")
