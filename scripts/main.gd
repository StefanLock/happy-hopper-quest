extends Node
@onready var screens: CanvasLayer = $Screens

const game = preload("uid://cikyu1m7q3dwx")
var game_in_progress = false

func _ready() -> void:
	DisplayServer.window_set_window_event_callback(_on_window_event)
	
	screens.start_game.connect(_on_screens_start_game)
	eventbus.pause_game.connect(_on_pause_game)
	
func _on_window_event(event):
	match event:
		DisplayServer.WINDOW_EVENT_FOCUS_OUT:
			if game_in_progress == true && !get_tree().paused:
				MyUtility.add_logs("Focus out: Paused game")
				_on_pause_game()
		DisplayServer.WINDOW_EVENT_CLOSE_REQUEST:
			get_tree().quit()

func _on_screens_start_game():
	var game_instance = game.instantiate()
	add_child(game_instance)
	game_instance.player_died.connect(_on_game_player_died)
	
	game_instance.new_game()
	game_in_progress = true
	
func _on_game_player_died(score, highscore):
	game_in_progress = false
	screens.end_game(score, highscore)

func _on_pause_game():
	get_tree().paused = true
	game_in_progress = false
	screens.pause_game()
