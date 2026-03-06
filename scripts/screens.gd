extends CanvasLayer

@onready var console_log: Control = $Debug/ConsoleLog
@onready var title_screen: Control = $TitleScreen
@onready var pause: Control = $Pause
@onready var game_over: Control = $GameOver
@onready var game_over_score_label = $GameOver/BlueBG/ColorRect/HighScoreLabel
@onready var game_over_best_score_label = $GameOver/BlueBG/ColorRect/BestScoreLabel

signal start_game

var current_screen = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	console_log.visible = false
	register_buttons()
	change_screen(title_screen)

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)

func _on_button_pressed(button):
	match  button.name:
		"TitlePlay":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()
		"TitleQuit":
			get_tree().quit(0)
		"PauseMenu":
			change_screen(title_screen)
			get_tree().paused = false
			eventbus.delete_level.emit()
		"PauseRetry":
			change_screen(null)
			await(get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
			start_game.emit()
		"PauseClose":
			change_screen(null)
			await(get_tree().create_timer(0.75).timeout)
			get_tree().paused = false
		"GameOverMenu":
			change_screen(title_screen)
			eventbus.delete_level.emit()
		"GameOverRetry":
			change_screen(null)
			await(get_tree().create_timer(0.5).timeout)
			start_game.emit()


func _on_toggle_console_pressed() -> void:
	console_log.visible = !console_log.visible

func change_screen(new_screen):
	
	if current_screen != null:
		await current_screen.disappear().finished
		current_screen.visible = false
		
	current_screen = new_screen
	
	if current_screen != null:
		current_screen.visible = true
		await current_screen.appear().finished
		get_tree().call_group("buttons", "set_disabled", false)

func end_game(score, highscore):
	await(get_tree().create_timer(0.75).timeout)
	game_over_score_label.text = "Score: " + str(score)
	game_over_best_score_label.text = "Best: " + str(highscore)
	change_screen(game_over)

func pause_game():
	change_screen(pause)
