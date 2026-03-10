extends CanvasLayer

@onready var score_hud: Control = %ScoreHUD
@onready var score_label: Label = %ScoreLabel

@onready var main_menu_hud: Control = %MainMenuHUD
@onready var main_sound_button: Button = %MainSoundButton

@onready var countdown_hud: Control = %CountdownHUD
@onready var countdown_label: Label = %CountdownLabel

@onready var pause_hud: Control = %PauseHUD
@onready var pause_sound_button: Button = %PauseSoundButton

@onready var game_over_hud: Control = %GameOverHUD
@onready var game_over: Label = %GameOver

var is_paused: bool = false

signal countdown_finished
signal start_single_player
signal start_two_player

func _ready() -> void:
	game_over_hud.visible = false

func update_score(p1_score: int, p2_score: int):
	score_label.text = str(p1_score) + " - " + str(p2_score)

func show_game_over(winner_text: String):
	game_over.text = winner_text
	game_over_hud.visible = true
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

func _on_single_player_pressed() -> void:
	main_menu_hud.visible = false
	score_hud.visible = true
	start_single_player.emit()

func _on_two_players_pressed() -> void:
	main_menu_hud.visible = false
	score_hud.visible = true
	start_two_player.emit()

func show_pause_menu(p_is_paused: bool):
	pause_hud.visible = p_is_paused

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

func toggle_sound():
	# Find the Master audio bus
	var master_bus = AudioServer.get_bus_index("Master")
	
	# Check if it is currently muted
	var is_muted = AudioServer.is_bus_mute(master_bus)
	
	# Flip the mute state to the opposite of what it currently is
	AudioServer.set_bus_mute(master_bus, not is_muted)
	
	# Update the text on both buttons
	var new_text = "Sound:  ON" if is_muted else "Sound: OFF"
	if main_sound_button: main_sound_button.text = new_text
	if pause_sound_button: pause_sound_button.text = new_text

func _on_pause_sound_button_pressed() -> void:
	toggle_sound()

func _on_main_sound_button_pressed() -> void:
	toggle_sound()
