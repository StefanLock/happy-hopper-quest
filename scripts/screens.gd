extends CanvasLayer

@onready var console_log: Control = $Debug/ConsoleLog
@onready var title_screen: Control = $TitleScreen
@onready var pause: Control = $Pause
@onready var game_over: Control = $GameOver

var current_screen = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	console_log.visible = false
	
	register_buttons()
	
	change_screen(title_screen)

func register_buttons():
	var buttons = get_tree().get_nodes_in_group("buttons")
	if buttons.size() > 0:
		for button in buttons:
			if button is ScreenButton:
				button.clicked.connect(_on_button_pressed)

func _on_button_pressed(button):
	match  button.name:
		"TitlePlay":
			print("Play button")
			change_screen(pause)
		"TitleQuit":
			pass
		"PauseMenu":
			change_screen(game_over)
		"PauseRetry":
			pass
		"PauseClose":
			pass
		"GameOverMenu":
			pass
		"GameOverRetry":
			pass
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_toggle_console_pressed() -> void:
	console_log.visible = !console_log.visible

func change_screen(new_screen):
	
	if current_screen != null:
		await current_screen.disappear().finished
		current_screen.visible = false
		
	current_screen = new_screen
	
	if current_screen != null:
		current_screen.visible = true
		await current_screen.appear().finished
		get_tree().call_group("buttons", "set_disabled", false)
		
