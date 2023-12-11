extends Camera2D

@onready var colorController = get_node('/root/ColorController')
var target_zoom = 1.5  # Set your desired target zoom level
var zoom_speed = 0.4  # Adjust the speed of the zoom

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	zoom.x = lerp(zoom.x, colorController.camZoom, delta*zoom_speed)
	zoom.y = lerp(zoom.y, colorController.camZoom, delta*zoom_speed)
