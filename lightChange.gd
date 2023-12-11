extends DirectionalLight2D

@onready var colorController = get_node('/root/ColorController')

var targetRotation : int
var transitionSpeed : float = 0.05
var isTransitioning : bool = false
var transitionTimer : float = 0.0
var transitionTime : float = 20.0  # Adjust the time for the full transition

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if targetRotation != colorController.lightDir:
		changeDirection(colorController.lightDir)
	if isTransitioning:
		transitionTimer += delta
		var currentRotation : int = rotation_degrees
		var target = targetRotation
		var angleDifference = (target - currentRotation + 180) % 360 - 180
		var rotationDelta = angleDifference * (transitionTimer / transitionTime) * transitionSpeed
		rotation_degrees += rotationDelta
		if transitionTimer >= transitionTime:
			isTransitioning = false
			transitionTimer = 0.0

func changeDirection(newRotation: int):
	targetRotation = newRotation
	isTransitioning = true
