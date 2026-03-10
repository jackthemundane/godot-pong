extends Node3D

@onready var ball = $Ball
@onready var ui_manager = $MainUI
@onready var player2_paddle = $Player2Paddle

@export var target_score: int = 3

var player1_score: int = 0
var player2_score: int = 0
var is_game_over: bool = false
var is_paused: bool = false

func _ready() -> void:
	ui_manager.update_score(player1_score, player2_score)

func _input(event):
	if event.is_action_pressed("pause") and not is_game_over:
		toggle_pause()
	
func _on_player_1_goal_goal_scored() -> void:
	player2_score += 1
	ui_manager.update_score(player1_score, player2_score)
	check_winner()
	
	if not is_game_over:
		start_new_round()

func _on_player_2_goal_goal_scored() -> void:
	player1_score += 1
	ui_manager.update_score(player1_score, player2_score)
	check_winner()
	
	if not is_game_over:
		start_new_round()

func check_winner():
	if player1_score >= target_score:
		is_game_over = true
		is_paused = true
		ui_manager.show_game_over("Player 1 Wins!")
	elif player2_score >= target_score:
		is_game_over = true
		is_paused = true
		ui_manager.show_game_over("Player 2 Wins!")

func start_new_round():
	ball.visible = true
	
	ball.global_position = Vector3.ZERO
	ball.velocity_vector = Vector3.ZERO
	
	ui_manager.play_countdown()
	await ui_manager.countdown_finished
	ball.reset()
	is_paused = false

func toggle_pause():
	is_paused = !is_paused
	ui_manager.show_pause_menu(is_paused)

func _on_main_ui_start_single_player() -> void:
	player2_paddle.is_ai = true
	player2_paddle.ball = ball
	start_new_round()

func _on_main_ui_start_two_player() -> void:
	player2_paddle.is_ai = false
	start_new_round()
