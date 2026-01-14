extends Node

@onready var platform_parent: Node2D = $PlatformParent

var camera_scene = preload("res://scenes/game_camera.tscn")
var platform_scene = preload("res://scenes/platform.tscn")

var start_platform_y
var y_distance_between_platforms = 100
var level_size = 50
var viewport_size
var generated_platform_count = 0

var camera = null

func _ready() -> void:
	camera = camera_scene.instantiate()
	camera.setup_camera($Player)
	add_child(camera)
	
	generated_platform_count = 0
	
	viewport_size = get_viewport().size
	start_platform_y = viewport_size.y - (y_distance_between_platforms*2)
	generate_level(start_platform_y, true)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func create_platform(location: Vector2):
	var platform = platform_scene.instantiate()
	platform.global_position = location
	platform_parent.add_child(platform)
	return platform

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
