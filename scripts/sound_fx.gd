extends Node

var sound = {
	"Music" = load("uid://duk11jmc6iyq"),
	"Click" = load("uid://c07g13wlqcmas"),
	"Jump" = load("uid://cwefybvgxyy7c")
}

@onready var sound_players = get_children()

func play(sound_name, bus, volume):
	var sound_to_play = sound[sound_name]
	for sound_player in sound_players:
		if !sound_player.playing:
			sound_player.bus = bus
			sound_player.stream = sound_to_play
			sound_player.volume_db = volume
			sound_player.play()
			return
	MyUtility.add_logs("Too many audio streams running, run out of players.")
