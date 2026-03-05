extends Node
@onready var screens: CanvasLayer = $Screens
#@onready var game: Node2D = $Game

const game = preload("uid://cikyu1m7q3dwx")

func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)

func _on_screens_start_game():
	var game_instance = game.instantiate()
	add_child(game_instance)
	
	game_instance.new_game()
