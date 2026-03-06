extends Control

@onready var hud_bar_bg: ColorRect = $HudBarBG
@onready var hud_bar: Control = $HudBar
@onready var score_label: Label = $HudBar/HBoxContainer/ScoreLabel

func _ready():
	var os_name = OS.get_name()
	
	if os_name == "Android":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		hud_bar.position.y += safe_area_top
		var margin = 10
		hud_bar_bg.size.y += safe_area_top + margin
		
		MyUtility.add_logs("safe area: " + str(safe_area))
		MyUtility.add_logs("safe area top: " + str(safe_area_top))
		MyUtility.add_logs("Window size: " + str(DisplayServer.window_get_size()))

func _on_pause_button_pressed() -> void:
	SoundFx.play("Click", "SoundFX", -14)
	eventbus.pause_game.emit()

func set_score(new_score):
	score_label.text = str(new_score)
