extends CanvasLayer

@onready var score_hud: Control = $"Score HUD"
@onready var score_label: Label = $"Score HUD/ScoreLabel"
@onready var game_over_menu: Control = $"Game Over HUD"
@onready var winner_label: Label = $"Game Over HUD/GameOver"
@onready var countdown_hud: Control = $"Countdown HUD"
@onready var countdown_label: Label = $"Countdown HUD/CountdownLabel"
@onready var main_menu_hud: Control = $"Main Menu Hud"
@onready var start_button: Button = $"Main Menu Hud/StartButton"
@onready var exit_button: Button = $"Main Menu Hud/ExitButton"
@onready var pause_hud: Control = $"Pause HUD"
@onready var resume_button: Button = $"Pause HUD/ResumeButton"
@onready var restart_button: Button = $"Pause HUD/RestartButton"
@onready var pause_exit_button: Button = $"Pause HUD/ExitButton"

var is_paused: bool = false

signal countdown_finished
signal game_started

func _ready() -> void:
	game_over_menu.visible = false

func update_score(p1_score: int, p2_score: int):
	score_label.text = str(p1_score) + " - " + str(p2_score)

func show_game_over(winner_text: String):
	winner_label.text = winner_text
	game_over_menu.visible = true
	score_hud.visible = false

func play_countdown():
	countdown_hud.visible = true
	
	for i in range(3, 0, -1):
		countdown_label.text = str(i)
		await get_tree().create_timer(1.0).timeout
	
	countdown_label.text = "GO!"
	await get_tree().create_timer(0.5).timeout    
	countdown_hud.visible = false
	countdown_finished.emit()

func _on_start_button_pressed() -> void:
	main_menu_hud.visible = false
	score_hud.visible = true
	game_started.emit()

func show_pause_menu(is_paused: bool):
	pause_hud.visible = is_paused

func _on_exit_button_pressed() -> void:
	get_tree().quit()

func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_resume_button_pressed() -> void:
	get_parent().toggle_pause()

func _on_play_again_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()
