extends Node2D

signal player_died(score, highscore)

var player: Player = null
var player_spawn_position: Vector2
var player_scene = preload("res://scenes/player.tscn")
var camera_scene = preload("res://scenes/game_camera.tscn")
var camera = null

var score: int = 0
var highscore: int = 0
var save_file_path = "user://highscore.save"

const DESIGN_WIDTH = 740.0
const DESIGN_HEIGHT = 1280.0

@onready var level_generator: Node2D = $LevelGenerator
@onready var ground_sprite: Sprite2D = $GroundSprite
@onready var parallax_layer_1: ParallaxLayer = $ParallaxBackground/ParallaxLayer1
@onready var parallax_layer_2: ParallaxLayer = $ParallaxBackground/ParallaxLayer2
@onready var parallax_layer_3: ParallaxLayer = $ParallaxBackground/ParallaxLayer3
@onready var parallax_layer_4: ParallaxLayer = $ParallaxBackground/ParallaxLayer4
@onready var hud: Control = $UILayer/HUD


func _ready() -> void:
	var actual_view_size = get_viewport_rect().size
	var player_spawn_offset = 10
	player_spawn_position.x = DESIGN_WIDTH / 2.0
	player_spawn_position.y = DESIGN_HEIGHT - player_spawn_offset
	
	ground_sprite.global_position.x = DESIGN_WIDTH / 2.0
	ground_sprite.global_position.y = actual_view_size.y
	
	var ground_tex_width = ground_sprite.texture.get_width()
	ground_sprite.scale.x = DESIGN_WIDTH / ground_tex_width * 1.05
	
	setup_parallax_layer(parallax_layer_1)
	parallax_layer_1.motion_offset.y = 30.0
	setup_parallax_layer(parallax_layer_2)
	setup_parallax_layer(parallax_layer_3)
	setup_parallax_layer(parallax_layer_4)
	
	hud.visible = false
	hud.set_score(0)
	
	load_score()
	
	eventbus.delete_level.connect(_on_screens_delete_level)

func get_parralax_sprite_scale(parallax_sprite: Sprite2D):
	var parallax_texture = parallax_sprite.get_texture()
	var parallax_texture_width = parallax_texture.get_width()

	var bg_h = parallax_sprite.texture.get_height() * parallax_sprite.scale.y
	parallax_layer_1.motion_mirroring = Vector2(0, bg_h)
	
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

	var viewport_size = get_viewport_rect().size.y
	if player:
		if score < viewport_size - player.global_position.y:
			score = (viewport_size - player.global_position.y)
			hud.set_score(score)

func new_game():
	eventbus.delete_level.emit()
	if is_instance_valid(player): player.queue_free()
	if is_instance_valid(camera): camera.queue_free()

	player = player_scene.instantiate()
	player.global_position = player_spawn_position
	player.died.connect(_on_player_died)
	add_child(player)
	
	camera = camera_scene.instantiate()
	add_child(camera)
	camera.setup_camera(player)
	
	if player:
		level_generator.setup(player)
		level_generator.start_generation()
	
	hud.visible = true
	score = 0

func _on_player_died():
	hud.visible = false

	if score > highscore:
		highscore = score
		save_score()

	player_died.emit(score, highscore)

func _on_screens_delete_level():
	hud.set_score(0)
	hud.visible = false
	level_generator.reset_level()
	if player != null:
		player.queue_free()
		player = null
		level_generator.player = null
	if camera != null:
		camera.queue_free()
		camera = null

func save_score():
	var file = FileAccess.open(save_file_path, FileAccess.WRITE)
	file.store_var(highscore)
	file.close()

func load_score():
	if FileAccess.file_exists(save_file_path):
		var file = FileAccess.open(save_file_path, FileAccess.READ)
		highscore = file.get_var()
		file.close()
	else:
		highscore = 0

func _on_hud_pause_game():
	eventbus.game_pause.emit()
