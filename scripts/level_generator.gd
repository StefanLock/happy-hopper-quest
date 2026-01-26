extends Node2D

@onready var platform_parent: Node2D = $PlatformParent

var platform_scene = preload("res://scenes/platform.tscn")

var start_platform_y
var y_distance_between_platforms = randf_range(100.0, 150.0)
var level_size = 15
var viewport_size
var generated_platform_count = 0

var player: Player = null

func setup(_player: Player):
	if _player:
		player = _player

func _ready() -> void:
	generated_platform_count = 0
	viewport_size = get_viewport().size
	start_platform_y = viewport_size.y - (y_distance_between_platforms*2)
	generate_level(start_platform_y, true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if player:
		var py = player.global_position.y
		var end_of_level_pos = start_platform_y - (generated_platform_count * y_distance_between_platforms)
		var threshold = end_of_level_pos + (y_distance_between_platforms * 5)
		if py <= threshold:
			generate_level(end_of_level_pos, false)

func generate_level(start_y: float, generate_ground: bool):
	var platform_width = 155
	
	if generate_ground == true:
		# Generate ground
		var platform_height = 37.5
		var ground_platform_count = (viewport_size.x / platform_width) + 1
		
		for i in range(ground_platform_count):
			var ground_location = Vector2(i * platform_width, viewport_size.y - platform_height)
			create_platform(ground_location)
	
	# Generate platforms	
	for i in range(level_size):
		var max_x_position = viewport_size.x - platform_width
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
