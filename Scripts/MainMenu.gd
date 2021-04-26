extends Node2D

onready var gemLabel = $CanvasLayer/MarginContainer/VBoxContainer/art/GemLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	var numGems = GameTracker.getGems()

	# Set LAdy Cerulean mood
	if(numGems <= 0):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean doesn't even know you exist."
	elif(GameTracker.getGems() <= 1):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean has taken notice of you."
	elif(GameTracker.getGems() <= 4):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean smiled at you the other day!"
	elif(GameTracker.getGems() <= 14):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean enjoys spending time with you."
	elif(GameTracker.getGems() <= 24):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean is impressed! She happily accepts your proposal!"
	elif(GameTracker.getGems() <= 34):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean sings to her gems in her private room."
	elif(GameTracker.getGems() <= 49):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nLady Cerulean craves more gems... At any cost."
	elif(GameTracker.getGems() <= 99):
		gemLabel.text = "Total Gems: " + str(numGems) + "\nWhat have you done..."
	
# Handle level select buttons
func _on_Level1_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level1.tscn")


func _on_Level2_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level2.tscn")


func _on_Level3_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level3.tscn")


func _on_Level4_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level4.tscn")


func _on_Level5_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level5.tscn")


func _on_Level6_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level6.tscn")


func _on_Level7_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level7.tscn")


func _on_Level8_B_pressed():
	get_tree().change_scene("res://Scenes/Levels/Level8.tscn")


func _on_Reset_pressed():
	GameTracker.resetGame()
