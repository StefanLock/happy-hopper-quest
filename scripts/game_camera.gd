extends Camera2D

@onready var destroyer: Area2D = $Destroyer
@onready var destroyer_shape: CollisionShape2D = $Destroyer/CollisionShape2D

var player: Player = null
var viewport_size 

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x
	
	destroyer.position.y = viewport_size.y / 2.0
	var rect_shape = RectangleShape2D.new()
	var rect_shape_size = Vector2(viewport_size.x, 200.0)
	rect_shape.set_size(rect_shape_size)
	destroyer_shape.shape = rect_shape
	
func _process(delta: float) -> void:
	if player:
		var limit_distance = 600
		if limit_bottom > player.global_position.y + limit_distance:
			limit_bottom = player.global_position.y + limit_distance

func setup_camera(_player: Player):
	if _player:
		player = _player

func _physics_process(delta: float) -> void:
	if player:
		global_position.y = player.global_position.y
