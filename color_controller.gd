extends Node

var myColor: Color
var skyColor: Color
var playerColor: Color

var skyIDX = 0
var colorIDX = 0
var lightDir : int = 15
var camZoom : float = 1.5
var cubeCount : int = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	myColor = Color(1,1,1,1)
	skyColor = Color(1,1,1,1)
	playerColor = Color(1,1,1,1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func resetGlobals():
	skyIDX = 0
	colorIDX = 0
	lightDir = 15
	camZoom = 1.5
	cubeCount = 0
