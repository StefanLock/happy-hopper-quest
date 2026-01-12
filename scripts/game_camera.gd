extends Camera2D

var player: Player = null
var viewport_size 

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	global_position.x = viewport_size.x / 2
	
	limit_bottom = viewport_size.y
	limit_left = 0
	limit_right = viewport_size.x
	
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
