extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer

var speed: float = 300.0
var gravity: float = 15.0
var jump_velocity: float = -800.0
var max_fall_velocity:float = 1000.0
var viewport_size: Vector2

func jump() -> void:
	velocity.y = jump_velocity

func _ready() -> void:
	viewport_size = get_viewport_rect().size

func _process(delta: float) -> void:
	if velocity.y > 0:
		if animation_player.current_animation != "fall":
			animation_player.play("fall")
	elif velocity.y < 0:
		if animation_player.current_animation != "jump":
			animation_player.play("jump")
	
func _physics_process(delta: float) -> void:
	# Making gravity and dropping the player in the Y axis
	velocity.y += gravity
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
	
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed/10)
		# Change the /10 to a bigger number to slow down stopping speed left and right.
	
	move_and_slide()
	# Margin to make the teleportation less jumpy.
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	elif global_position.x < - margin:
		global_position.x = viewport_size.x + margin
