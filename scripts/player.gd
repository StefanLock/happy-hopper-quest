extends CharacterBody2D
class_name Player

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D

var speed: float = 300.0
var gravity: float = 15.0
var jump_velocity: float = -800.0
var max_fall_velocity:float = 1000.0
var viewport_size: Vector2
var do_a_flip: Tween

var use_accelerometer: bool = false
var accelerometer_speed = 130

func flip() -> void:
	do_a_flip = create_tween()
	var flip_dir = [-1, 1].pick_random()
	do_a_flip.tween_property(sprite_2d, "rotation_degrees", 360.0 * flip_dir, 0.6).as_relative()

func jump() -> void:
	if randf() < 0.5:
		flip()

	velocity.y = jump_velocity

func _ready() -> void:
	viewport_size = get_viewport_rect().size
	
	var os_name = OS.get_name()
	if os_name == "Android":
		use_accelerometer = true

func _process(_delta: float) -> void:
	if velocity.y > 0:
		if animation_player.current_animation != "fall":
			animation_player.play("fall")
	elif velocity.y < 0:
		if animation_player.current_animation != "jump":
			animation_player.play("jump")
	
func _physics_process(_delta: float) -> void:
	# Making gravity and dropping the player in the Y axis
	velocity.y += gravity
	if velocity.y > max_fall_velocity:
		velocity.y = max_fall_velocity
		
	if use_accelerometer == true:
		var mobile_input = Input.get_accelerometer()
		velocity.x = mobile_input.x * accelerometer_speed
	else:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed/10)
	
	move_and_slide()
	# Margin to make the teleportation less jumpy.
	var margin = 20
	if global_position.x > viewport_size.x + margin:
		global_position.x = -margin
	elif global_position.x < - margin:
		global_position.x = viewport_size.x + margin
