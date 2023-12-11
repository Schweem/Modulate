extends Sprite2D

# Rotation speed in degrees per second
var rotation_speed: float = 45.0

# Scaling parameters
var start_scale: float = 3.0
var min_scale: float = 0.5
var max_scale: float = 5.0
var scaling_speed: float = 1.0
var is_scaling_up: bool = true

# Hue change parameters
var hue_change_speed: float = 1.0  # Adjust the speed as needed
var original_hue: float = randf_range(0.0, 1.0)  # Initial random hue
var current_hue: float = original_hue  # Current hue

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# Rotate the sprite based on the elapsed time and rotation speed
	rotate(deg_to_rad(rotation_speed) * delta)
	change_hue(delta)
	# Scale the sprite
	scale_sprite(delta)

func scale_sprite(delta):
	# Determine the scaling direction
	var scale_direction: int

	if is_scaling_up:
		scale_direction = 1
	else:
		scale_direction = -1

	# Calculate the new scale factor
	var new_scale: float = start_scale + scale_direction * scaling_speed * delta

	# Check if the scale exceeds the limits
	if is_scaling_up:
		if new_scale > max_scale:
			new_scale = max_scale
			is_scaling_up = false
	else:
		if new_scale < min_scale:
			new_scale = min_scale
			is_scaling_up = true

	# Apply the new scale as a Vector2
	scale = Vector2(new_scale, new_scale)
	
func change_hue(delta):
	# Calculate the new hue
	current_hue += hue_change_speed * delta
	# Ensure the hue is within the valid range (0.0 to 1.0)
	current_hue = fmod(current_hue, 1.0)
	# Set the new hue in the modulate property
	modulate = Color(current_hue, 1.0, 1.0)
