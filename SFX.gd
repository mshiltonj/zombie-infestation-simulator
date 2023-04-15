extends Node2D


const SOUNDS= {
	"click": preload("res://assets/sounds/click5.ogg"),
	"hover": preload("res://assets/sounds/rollover6.ogg")
}

@onready var audio_player = AudioStreamPlayer2D.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(audio_player)

func play(sample):
	audio_player.stream = SOUNDS[sample]
	audio_player.play()
