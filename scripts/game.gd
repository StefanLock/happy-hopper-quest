extends Node2D

@onready var player: Player = $Player
@onready var level_generator: Node2D = $LevelGenerator

var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

func _ready() -> void:
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)
	
	if player:
		level_generator.setup(player)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
