extends Node2D

var player: Player = null
var player_spawn_position: Vector2
var player_scene = preload("res://scenes/player.tscn")
var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

const DESIGN_WIDTH = 740.0
const DESIGN_HEIGHT = 1280.0

@onready var level_generator: Node2D = $LevelGenerator
@onready var ground_sprite: Sprite2D = $GroundSprite
@onready var parallax_layer_2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer_3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3
@onready var parallax_layer_4: ParallaxLayer = $ParallaxBackground/ParallaxLayer4

func _ready() -> void:
	var actual_view_size = get_viewport_rect().size
	
	var player_spawn_offset = 50
	player_spawn_position.x = DESIGN_WIDTH / 2.0
	player_spawn_position.y = DESIGN_HEIGHT - player_spawn_offset
	
	ground_sprite.global_position.x = DESIGN_WIDTH / 2.0
	ground_sprite.global_position.y = actual_view_size.y
	
	var ground_tex_width = ground_sprite.texture.get_width()
	ground_sprite.scale.x = DESIGN_WIDTH / ground_tex_width * 1.05

	setup_parallax_layer(parallax_layer_2)
	setup_parallax_layer(parallax_layer_3)
	setup_parallax_layer(parallax_layer_4)
	
	new_game.call_deferred()

func get_parralax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()
	
	var _scale = DESIGN_WIDTH / parallax_texture_width
	return Vector2(_scale, _scale)
	
func setup_parallax_layer(_parallax_layer: ParallaxLayer):
	var parallax_sprite = _parallax_layer.find_child("Sprite2D")
	
	if parallax_sprite != null:
		var parallax_scaled = get_parralax_sprite_scale(parallax_sprite)
		parallax_sprite.scale = parallax_scaled
		var bg_h = parallax_sprite.texture.get_height() * parallax_sprite.scale.y
		var ground_h = ground_sprite.texture.get_height() * ground_sprite.scale.y
		var ground_top_y = ground_sprite.global_position.y - (ground_h / 2.0)
		parallax_sprite.global_position.x = DESIGN_WIDTH / 2.0
		parallax_sprite.global_position.y = ground_top_y - (bg_h / 2.0)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().call_deferred("reload_current_scene")

func new_game():
	if is_instance_valid(player): player.queue_free()
	if is_instance_valid(camera): camera.queue_free()

	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	add_child(player)
	
	camera = camera_scene.instantiate()
	add_child(camera)
	camera.setup_camera(player)
	
	if player:
		level_generator.setup(player)
