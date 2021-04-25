extends Node2D

onready var gemLabel = $CanvasLayer/MarginContainer/VBoxContainer/art/GemLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _process(delta):
	gemLabel.text = "Total Gems: " + str(GameTracker.getGems())
	
	
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
