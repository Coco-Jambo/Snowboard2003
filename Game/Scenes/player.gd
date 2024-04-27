extends CharacterBody2D

@onready var _animated_sprite = $AnimatedSprite2D
@onready var _audio_player = $AudioStreamPlayer2D

@export var BASE_SPEED = 80.0
@export var SPEED_MODIFIER = 100
@export var MAX_SPEED = 1000.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const JUMP_VELOCITY_STEP = 10
var jump_power_initial = -500 
var jump_power = 0 
var jump_time_max = 0.08
var jump_timer = 0.0
var is_jumping = false
var floor_normal = Vector2.ZERO


#audio
var random_integer
var selected_sound

@onready var wow = $wow
@onready var _360 = $"360"
@onready var aaaa = $AAAA
@onready var omg = $omg
@onready var ooh = $ooh
@onready var ouch_1 = $ouch1
@onready var yes = $Yes
@onready var alright = $Alright


var jump_sounds = [wow, _360, omg, yes, alright]
var ouch_sounds = [ouch_1, ooh, aaaa]


func apply_jump_force(power):
	velocity.y = power
	
func score_count(delta):
	#score count
	if (fmod(_animated_sprite.rotation_degrees,360) == 0 or ( fmod(_animated_sprite.rotation_degrees,360) <= -337 and fmod(_animated_sprite.rotation_degrees,360) >= -359)) and _animated_sprite.rotation_degrees != 0:
		Global.score += 500
		print(_animated_sprite.rotation_degrees)
		print(Global.score)
		_animated_sprite.rotation_degrees = 0
		play_rand_jump()
		
	if not is_on_floor():
		velocity.y += (gravity * 3) * delta
		if Input.is_action_pressed("up"):
			_animated_sprite.rotation_degrees -= 20.0
		_animated_sprite.rotation_degrees -= 1.0
		

func _physics_process(delta):
	

	if is_on_floor():
		jump_timer = 0.0
		is_jumping = false
		
		#sprite tilt handling
		#getting the normal information
		floor_normal =get_floor_normal()
		
		# Calculate the rotation angle based on the floor normal
		var slope_angle = atan2(floor_normal.x, -floor_normal.y)

		# Set the rotation of the sprite to match the slope angle
		_animated_sprite.rotation_degrees = slope_angle * 180 / PI
		
		#default animation
		if _animated_sprite.animation != "ouch":
			_animated_sprite.play("default")
		
		if velocity.x >= 400:
			_animated_sprite.play("speed")
			
		if Input.is_action_just_pressed("jump"):
			jump_timer = 0.0
			is_jumping = true
			apply_jump_force(jump_power_initial)
			jump_power = jump_power_initial
			_animated_sprite.rotation_degrees = 0
			_animated_sprite.play("jump")
			
	else:
		jump_timer += delta


	if Input.is_action_pressed("jump") and is_jumping and jump_timer < jump_time_max:
		jump_power -= JUMP_VELOCITY_STEP
		apply_jump_force(jump_power)
		

	# Acceleration
	velocity.x += (0.5 + BASE_SPEED) * delta
	velocity.y += (0.5 + BASE_SPEED) * delta
		
	move_and_slide()
	score_count(delta)


func _on_hazard_detector_body_entered(body):
	Global.score -=250
	_animated_sprite.play("ouch")
	play_rand_ouch()
	

func play_rand_jump():
	random_integer = randi_range(0,4)
	match random_integer:
		0:
			wow.play()
		1:
			_360.play()
		2:
			omg.play()
		3:
			yes.play()
		4:
			alright.play()
	
func play_rand_ouch():
	random_integer = randi_range(0, 3)
	match random_integer:
		0:
			ouch_1.play()
		1:
			ooh.play()
		2:
			aaaa.play()
	
	
