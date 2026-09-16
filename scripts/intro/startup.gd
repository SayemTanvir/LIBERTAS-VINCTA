extends "res://scripts/intro/estate_cinematic.gd"
## Every application launch plays the exterior before exposing menu input.
func _ready() -> void:
	GameManager.state = GameManager.State.INTRO
	super._ready()
	finished.connect(GameManager.go_home, CONNECT_DEFERRED)
