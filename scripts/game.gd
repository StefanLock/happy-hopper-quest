extends Node2D

var player: Player = null
var player_spawn_position: Vector2
var player_scene = preload("res://scenes/player.tscn")
var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

var viewport_size: Vector2

@onready var level_generator: Node2D = $LevelGenerator
@onready var ground_sprite: Sprite2D = $GroundSprite
@onready var parallax_layer_2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer_3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3
@onready var parallax_layer_4: ParallaxLayer = $ParallaxBackground/ParallaxLayer4

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	var player_spawn_offset = 150
	player_spawn_position.x = viewport_size.x / 2.0
	player_spawn_position.y = viewport_size.y - player_spawn_offset
	
	ground_sprite.global_position.x = viewport_size.x / 2.0
	ground_sprite.global_position.y = viewport_size.y

	setup_parallax_layer(parallax_layer_2)
	setup_parallax_layer(parallax_layer_3)
	setup_parallax_layer(parallax_layer_4)
	new_game()

func get_parralax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	
	var _scale = viewport_size.x / parallax_texture_width
	var result = Vector2(_scale, _scale)
	return result
	
func setup_parallax_layer(_parallax_layer: ParallaxLayer):
	var parallax_sprite = _parallax_layer.find_child("Sprite2D")
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_height = parallax_texture.get_height()
	
	if parallax_sprite != null:
		parallax_sprite.scale = get_parralax_sprite_scale(parallax_sprite)
		parallax_sprite.offset.y = parallax_texture_height

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func new_game():
	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	add_child(player)
	
	camera = camera_scene.instantiate()
	camera.setup_camera(player)
	add_child(camera)
	
	if player:
		level_generator.setup(player)
