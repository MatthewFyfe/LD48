extends Node2D

var totalGems = 1
var levelsComplete = [0,0,0,0,0,0,0,0]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# make as if new
func resetGame():
	totalGems = 0
	levelsComplete = [0,0,0,0,0,0,0,0]

func getGems():
	return totalGems
	
func incGems(number):
	totalGems += number
	
func completeLevel(number):
	levelsComplete[number-1] = 1
