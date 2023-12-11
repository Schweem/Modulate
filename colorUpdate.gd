extends ColorRect

@onready var colorController = get_node('/root/ColorController')

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	color = colorController.myColor 
