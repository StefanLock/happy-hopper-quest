extends Node
@onready var screens: CanvasLayer = $Screens
@onready var game: Node2D = $Game

func _ready() -> void:
	screens.start_game.connect(_on_screens_start_game)

func _on_screens_start_game():
	game.new_game()
