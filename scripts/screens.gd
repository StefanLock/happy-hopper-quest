extends CanvasLayer

@onready var console_log: Control = $Debug/ConsoleLog


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	console_log.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_toggle_console_pressed() -> void:
	console_log.visible = !console_log.visible
