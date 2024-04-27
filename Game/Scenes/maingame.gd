extends Node2D
@onready var character_body_2d = $CharacterBody2D
@onready var main = $main
@onready var plug = $plug

var reached = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("reset"):
		character_body_2d.position.x = 0
		character_body_2d.position.y = 0
		character_body_2d.velocity.x = 0
		Global.score = 0
	
	if character_body_2d.position.x >= 40600 and not reached:
		plug.play()
		reached = true
	
