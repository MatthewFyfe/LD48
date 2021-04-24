extends Area2D

onready var waterLevel = $CollisionShape2D

var risingRate = 0
var gemPower = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# every physics tick
func _physics_process(delta):
	var newHeight = waterLevel.get_shape().extents + Vector2(0, risingRate*delta)
	waterLevel.get_shape().set_extents(newHeight)

func _on_TestCharacter_gemMined():
	#increase water rising rate
	risingRate += gemPower
