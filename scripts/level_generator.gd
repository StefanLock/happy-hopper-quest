extends Node2D

@onready var platform_parent: Node2D = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")

const DESIGN_WIDTH = 740.0
const DESIGN_HEIGHT = 1280.0

var start_platform_y
var y_distance_between_platforms = 100.0
var level_size = 50
var generated_platform_count = 0

var player: Player = null

func setup(_player: Player):
	if _player:
		player = _player
	
func _ready() -> void:
	generated_platform_count = 0
	start_platform_y = DESIGN_HEIGHT - (y_distance_between_platforms)
	
	generate_level(start_platform_y, true)
	
func _process(_delta: float) -> void:
	if player:
		var py = player.global_position.y
		var end_of_level_pos = start_platform_y - (generated_platform_count * y_distance_between_platforms)
		var threshold = end_of_level_pos + (y_distance_between_platforms * 5)
		if py <= threshold:
			generate_level(end_of_level_pos, false)

func generate_level(start_y: float, generate_ground: bool):
	var platform_width = 155
	var current_view_size = get_viewport().get_visible_rect().size
	
	if generate_ground == true:
		var ground_platform_count = (current_view_size.x / platform_width) + 1
		
		for i in range(ground_platform_count):
			var ground_location = Vector2(i * platform_width, current_view_size.y)
			create_platform(ground_location)

	for i in range(level_size):
		var max_x_position = DESIGN_WIDTH - platform_width
		var random_x = randf_range(0.0, max_x_position)
		
		var location: Vector2
		location.x = random_x
		location.y = start_y - (y_distance_between_platforms * i)

		create_platform(location)
		generated_platform_count += 1

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform
