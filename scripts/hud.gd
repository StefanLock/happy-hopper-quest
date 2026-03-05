extends Control

@onready var hud_bar_bg: ColorRect = $HudBarBG
@onready var hud_bar: Control = $HudBar

func _ready():
	var os_name = OS.get_name()
	
	if os_name == "Andorid":
		var safe_area = DisplayServer.get_display_safe_area()
		var safe_area_top = safe_area.position.y
		
		hud_bar.position.y += safe_area_top
		var margin = 10
		hud_bar_bg.position.y += safe_area_top + margin
		
		MyUtility.add_logs("safe area: " + str(safe_area))
		MyUtility.add_logs("safe area top: " + str(safe_area_top))
		MyUtility.add_logs("Window size: " + str(DisplayServer.window_get_size()))

func _on_pause_button_pressed() -> void:
	pass # Replace with function body.
