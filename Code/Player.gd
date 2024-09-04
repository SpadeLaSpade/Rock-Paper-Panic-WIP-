extends Node2D

var score: int = 0


func logic(choice: String):
	var outcomes = {"Rock": "Scissors", "Paper": "Rock", "Scissors": "Paper"}
	var enemy_choice = %Enemy.choice
	
	if outcomes[choice] == enemy_choice:
		score += 1
		%Enemy.choice = %Enemy.options.pick_random()
		%Countdown.reset_timer()
	elif outcomes[enemy_choice] == choice:
		score = 0
		%Countdown.end_game("lose")
	
	%Score.text = "Score: " + str(score)


func _on_rock_pressed():
	logic("Rock")


func _on_paper_pressed():
	logic("Paper")


func _on_scissors_pressed():
	logic("Scissors")


func retry():
	get_tree().reload_current_scene()
