extends CanvasLayer

var airLevel = 100
var gemCount = 0

onready var gemLabel = $GemMeter
onready var airLabel = $AirMeter

#Water stuff
var drowning = false
signal playerDead

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	handleDrowning(delta)
	
	#update HUD
	gemLabel.text = "Gems: " + str(gemCount)
	airLabel.text = "Air Level: " + str(stepify(airLevel,1)) + "%"


# Check and adjust air levels
func handleDrowning(delta):
	if(drowning and airLevel > -1):
		airLevel -= 5*delta
	elif(airLevel < 100):
		airLevel += 15*delta
		
	airLevel = clamp(airLevel, -1, 100)
	
	#check if we are dead
	if(airLevel < 0):
		emit_signal("playerDead")


func _on_TestCharacter_gemMined():
	gemCount += 1
	GameTracker.incGems(1)


func _on_TestCharacter_playerDrowning():
	drowning = true


func _on_TestCharacter_playerNotDrowning():
	drowning = false
