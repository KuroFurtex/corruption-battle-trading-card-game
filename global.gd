extends Node

var musicList: Array = [
	preload("res://music/meganeko - Milkshake (Lofi Edit-CBTCG Theme).mp3")
]

var fullscreen: bool
var currentWindow: DisplayServer.WindowMode

var currentCard: String
var music: AudioStreamPlayer = AudioStreamPlayer.new()
var cardMove: AudioStreamPlayer = AudioStreamPlayer.new()
var cardFlip: AudioStreamPlayer = AudioStreamPlayer.new()
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music.stream = musicList.pick_random()
	music.bus = "music"
	music.finished.connect(change_song)
	add_child(music)
	# music.play()
	
	cardFlip.stream = AudioStreamRandomizer.new()
	cardFlip.stream.add_stream(0, preload("res://sound/card-flip.wav"))
	cardFlip.stream.random_pitch = 1.3
	cardFlip.pitch_scale = 1.2
	cardFlip.bus = "sound"
	cardFlip.max_polyphony = 2
	add_child(cardFlip)
	
	cardMove.stream = AudioStreamRandomizer.new()
	cardMove.stream.add_stream(0, preload("res://sound/card-move.wav"))
	cardMove.stream.random_pitch = 1.3
	cardMove.pitch_scale = 1.2
	cardMove.bus = "sound"
	cardMove.max_polyphony = 2
	add_child(cardMove)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_fullscreen"):
		fullscreen = !fullscreen
		if fullscreen:
			currentWindow = DisplayServer.window_get_mode()
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(currentWindow)
	if event is InputEventMouseButton:
		if !event.pressed:
			Global.currentCard = ""

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_song():
	music.stream = musicList.pick_random()
	music.play()
