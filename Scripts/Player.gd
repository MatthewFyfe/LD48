extends KinematicBody2D

var velocity
var speed
var gravity
var acceleration
var airFriction
var jumpForce

signal playerCollided
signal gemMined
signal playerDrowning
signal playerNotDrowning

onready var pSprite = $AnimatedSprite

#Pickaxe stuff
onready var pPick = $Pickaxe
onready var pHitBox = $Collision_Body
var hitBox_playerOnly
var hitBox_withPickRight
var hitBox_withPickLeft
var hitBox_withPickDown
onready var digArea = $Pickaxe/Area2D
onready var tileMap = self.get_parent().get_child(0)

var airTileNum = -1

#Audio stuff
onready var backgroundAudio = $BackgroundAudio
onready var backgroundAudio2 = $BackgroundAudio2
onready var soundEffects = $SoundEffects

var drowningBackground = preload("res://SFX/drowning.ogg")
var caveBackground = preload("res://SFX/CaveTheme.ogg")
var digSFX = preload("res://SFX/dig.ogg")
var gemSFX = preload("res://SFX/gem.ogg")
var pickSFX = preload("res://SFX/pickaxe.ogg")

# Called when the node enters the scene tree for the first time.
func _ready():
	velocity = Vector2(0,0)
	speed = 90
	gravity = 200
	acceleration = 0.3
	airFriction = 0.05
	jumpForce = -150
	
	digSFX.loop = false
	gemSFX.loop = false
	pickSFX.loop = false
	
	backgroundAudio2.play()
	
	setup_hitBoxes()

# Every frame...
func _process(_delta):
	handlePlayerInput()
	updateAnimations()


# Every physics tic...
func _physics_process(delta):
	handlePlayerMovment(delta)


# Configure player and pickaxe hitboxes
func setup_hitBoxes():
	#HitBox variations
	hitBox_withPickRight = pHitBox.get_polygon()
	
	#flip X on all vertices
	hitBox_withPickLeft = pHitBox.get_polygon()
	hitBox_withPickLeft.set(0,Vector2(-16,-48))
	hitBox_withPickLeft.set(1,Vector2(-42,-48))
	hitBox_withPickLeft.set(2,Vector2(-42,-24))
	hitBox_withPickLeft.set(3,Vector2(-16,-23))
	hitBox_withPickLeft.set(4,Vector2(-16,24))
	hitBox_withPickLeft.set(5,Vector2(16,24))
	hitBox_withPickLeft.set(6,Vector2(16,-24))
	hitBox_withPickLeft.set(7,Vector2(-16,-24))
		
	#Set 0,1,2 = 3 to close pick box
	hitBox_playerOnly = pHitBox.get_polygon()
	hitBox_playerOnly.set(0,hitBox_withPickRight[3])
	hitBox_playerOnly.set(1,hitBox_withPickRight[3])
	hitBox_playerOnly.set(2,hitBox_withPickRight[3])
	
	#Cheat.. and just make player taller for "down" dig hitbox
	hitBox_withPickDown = hitBox_playerOnly
	hitBox_withPickDown.set(4,Vector2(16,42))
	hitBox_withPickDown.set(5,Vector2(-16,42))
	
	pHitBox.set_polygon(hitBox_playerOnly)
	
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
		
		
	# Pickaxe controls
	if(Input.is_action_pressed("ui_select")):
		
		#Make the pick visible
		if(pPick.visible == false):
			pPick.show()
		
		#Check if we are digging DOWN
		if(Input.is_action_pressed("ui_down")):
			pPick.position.x = 0
			pPick.position.y = 42
			pPick.flip_v = true
			
			#Check for dig, then update polygon
			checkForDig()
			pHitBox.set_polygon(hitBox_withPickDown)
		else:
			pPick.position.y = -24
			pPick.flip_v = false
		
			#Update hitbox & pickaxe position
			if(velocity.x > 0):
				pPick.position.x = 30
				pPick.flip_h = false
				
				#Check for dig, then update polygon
				checkForDig()
				pHitBox.set_polygon(hitBox_withPickRight)
			else:
				pPick.position.x = -30
				pPick.flip_h = true
				
				#Check for dig, then update polygon
				checkForDig()
				pHitBox.set_polygon(hitBox_withPickLeft)
	else:
		if(pPick.visible == true):
			pPick.hide()
			#Update hitbox
			pHitBox.set_polygon(hitBox_playerOnly)
			


# Before we adjust the hitbox, check if we should dig the tile we hit
func checkForDig():
	#Update dig area location (handled by pickaxe move)
	
	#Check for bodies in area
	var digLocation = digArea.global_position
	var targetTile = tileMap.get_cellv(tileMap.world_to_map(digLocation))
	var tileName = tileMap.tile_set.tile_get_name(targetTile)
	
	if(tileName == "Dirt"):
		#play dig sound
		soundEffects.stream = digSFX
		soundEffects.play(0.75)
		tileMap.set_cellv(tileMap.world_to_map(digLocation), airTileNum)
		#spawn dirt particles
		spawnDirt()
		
	elif(tileName == "Gem"):
		#play gem sound
		soundEffects.stream = gemSFX
		soundEffects.play(0.1)
		tileMap.set_cellv(tileMap.world_to_map(digLocation), airTileNum)
		emit_signal("gemMined")
	elif(tileName == "Exit"):
		get_tree().change_scene("res://Scenes/MainMenu.tscn")
	else:
		#we hit nothing, woosh!
		if(Input.is_action_just_pressed("ui_accept")):
			soundEffects.stream = pickSFX
			soundEffects.play(0.5)


func spawnDirt():
	var scene = load("res://Scenes/Prefabs/DigParticles.tscn")
	var dirt = scene.instance()
	dirt.emitting = true
	add_child(dirt)

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
		velocity.y = clamp(velocity.y + delta * gravity, jumpForce, -jumpForce)
	velocity.x = clamp(velocity.x, -speed, speed)
	
	# Update character position
	#move_and_slide_with_snap(velocity * speed * delta,  Vector2.DOWN, Vector2.UP, false)
	move_and_slide(velocity * speed * delta, Vector2.UP)
	
	# Check if we hit anything cool
	if get_slide_count() != 0 :
		for i in range (0,get_slide_count()) :
			emit_signal("playerCollided", self, get_slide_collision(i))

func _on_HUD_playerDead():
	#we drowned... no gems for you!
	GameTracker.resetGame()
	get_tree().change_scene("res://Scenes/MainMenu.tscn")
	


func _on_WaterLevel_area_entered(_area, source):
	if(source == "water"):
		gravity = 50
		emit_signal("playerDrowning")
		
		#play drowning sfx
		backgroundAudio.stream = drowningBackground
		backgroundAudio.play(1)

func _on_WaterLevel_area_exited(_area, source):
	if(source == "water"):
		gravity = 200
		emit_signal("playerNotDrowning")
		
		#stop drowning sfx
		backgroundAudio.stop()
