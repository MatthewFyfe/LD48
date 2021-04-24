extends KinematicBody2D

var velocity
var speed
var gravity
var acceleration
var airFriction
var jumpForce

signal playerCollided

onready var pSprite = $AnimatedSprite

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0,0)
	speed = 75
	gravity = 200
	acceleration = 0.2
	airFriction = 0.05
	jumpForce = -90

# Every frame...
func _process(_delta):
	handlePlayerInput()
	updateAnimations()


# Every physics tic...
func _physics_process(delta):
	handlePlayerMovment(delta)
	
	
# Check which keys are pressed, respond appropriately
func handlePlayerInput():
	# Check if we are on the ground before controlling
	var onFloor = is_on_floor()
	
	# Walk left/right (acceleration)
	if Input.is_action_pressed("ui_left"):
		if(onFloor):
			velocity.x = lerp(velocity.x, -speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, -speed, airFriction)
	elif Input.is_action_pressed("ui_right"):
		if(onFloor):
			velocity.x = lerp(velocity.x, speed, acceleration)
		else:
			velocity.x = lerp(velocity.x, speed, airFriction)
	# Otherwise, slow down (friction)
	else:
		if(onFloor):
			velocity.x = lerp(velocity.x, 0, acceleration)
		else:
			velocity.x = lerp(velocity.x, 0, airFriction)
		
	# Jump if we are able to do so
	if (Input.is_action_pressed("ui_up") and is_on_floor()):
		velocity.y = jumpForce

	# Smaller jump if key released early
	if (Input.is_action_just_released("ui_up") and !onFloor and velocity.y < 0):
		velocity.y /= 2


# Handle player animations as their state changes
func updateAnimations():
	# Update facing
	if(velocity.x > 0):
		pSprite.flip_h = false
	else:
		pSprite.flip_h = true

	# Toggle rise / fall /stand / walk
	if(velocity.y < -1):
		pSprite.animation = "Rising"
	elif(velocity.y > 2 and !is_on_floor()):
		pSprite.animation = "Falling"
	elif(abs(velocity.x) < 10):
		pSprite.animation = "Standing"
	else:
		pSprite.animation = "Walking"


# Move the player character around in the world based on their velocity
func handlePlayerMovment(delta):
	# Apply Gravity and Clamp x,y speeds
	if(!is_on_floor()):
		velocity.y = clamp(velocity.y + delta * gravity, -speed, speed)
	velocity.x = clamp(velocity.x, -speed, speed)
	
	# Update character position
	#move_and_slide_with_snap(velocity * speed * delta,  Vector2.DOWN, Vector2.UP, false)
	move_and_slide(velocity * speed * delta, Vector2.UP)
	
	# Check if we hit anything cool
	if get_slide_count() != 0 :
		for i in range (0,get_slide_count()) :
			emit_signal("playerCollided", self, get_slide_collision(i))
