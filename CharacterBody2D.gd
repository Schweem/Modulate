extends CharacterBody2D

const SPEED = 300.0
const COYOTE_TIME = 0.1
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var coyoteTimer = 0.0

# Character color transition variables
var targetCharacterColor : Color
var transitionSpeedCharacter : float = 1.0
var transitionTimerCharacter : float = 0.0
var isTransitioningCharacter : bool = false
var transitionTimeCharacter = 3.0

# Sky color transition variables
var targetSkyColor : Color
var transitionSpeedSky : float = 1.0
var transitionTimerSky : float = 0.0
var isTransitioningSky : bool = false
var transitionTimeSky = 3.0

var lastPos : Vector2
@onready var myShadow = $ColorRect/LightOccluder2D
@onready var canLand = false
@onready var fadeAway = false

var skyList = [(Color("#F4F4F8")),(Color("#FCFCFC")),(Color("#EFCB68")),(Color("#6aa84f"))]
var colorList = [(Color("#E6E6EA")),(Color("#3DDC97")),(Color("#160C28")), (Color("#9fc5e8"))]

@onready var myBox = $ColorRect
@onready var colorController = get_node('/root/ColorController')
@onready var audioPlayer = $AudioStreamPlayer2D
@onready var startPos = position

func _physics_process(delta):
	handleGravity(delta)
	handleJump()
	handleColorTransition(delta)
	handleMovement()

func handleGravity(delta):
	if not is_on_floor():
		canLand = true
		velocity.y += gravity * delta
		coyoteTimer -= delta
		resetScale(0.75, 1.6)
		if velocity.y > 2000:
			startColorTransitionSky(Color("#F4F4F8"))
			startColorTransitionCharacter(Color("#E6E6EA"))
			position = lastPos
			startColorTransitionSky(getRandomColor())
			startColorTransitionCharacter(getRandomColor())
	else:
		if canLand:
			playSound("landing")
			canLand = false
		if is_on_floor_only():
			lastPos = position
		coyoteTimer = COYOTE_TIME
		resetScale(1,1)

func handleJump():
	if Input.is_action_just_pressed("jump") and coyoteTimer > 0:
		velocity.y = JUMP_VELOCITY   
		playSound("jump")
		
	if Input.is_action_just_released("jump") and velocity.y < 0:
		if colorController.cubeCount < 7:
			velocity.y = velocity.y / 4

func startColorTransitionCharacter(newColor: Color):
	targetCharacterColor = newColor
	isTransitioningCharacter = true

func startColorTransitionSky(newColor: Color):
	targetSkyColor = newColor
	isTransitioningSky = true

func handleColorTransition(delta):
	if isTransitioningCharacter:
		transitionTimerCharacter += delta
		colorController.myColor = interpolateColor(colorController.myColor, targetCharacterColor, delta * transitionSpeedCharacter)

		if transitionTimerCharacter >= transitionTimeCharacter:
			isTransitioningCharacter = false
			transitionTimerCharacter = 0.0

	if isTransitioningSky:
		transitionTimerSky += delta
		colorController.skyColor = interpolateColor(colorController.skyColor, targetSkyColor, delta * transitionSpeedSky)

		if transitionTimerSky >= transitionTimeSky:
			isTransitioningSky = false
			transitionTimerSky = 0.0

func interpolateColor(startColor: Color, endColor: Color, alpha: float) -> Color:
	return Color(
		startColor.r + (endColor.r - startColor.r) * alpha,
		startColor.g + (endColor.g - startColor.g) * alpha,
		startColor.b + (endColor.b - startColor.b) * alpha,
		startColor.a + (endColor.a - startColor.a) * alpha
	)

func handleMovement():
	var direction = Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			myBox.play("walk")
		#resetScale(1.2, .90)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		myBox.play("idle")
	
	if velocity.y != 0:
		myBox.play("idle")
	move_and_slide()
	
	if colorController.cubeCount == 3:
		startColorTransitionCharacter(Color("#EEE4E1"))
		startColorTransitionSky(Color("#E7D8C9"))
	
	if colorController.cubeCount == 6:
		startColorTransitionCharacter(Color(1,1,1,1))
		startColorTransitionSky(Color("#EC0B43"))

func _on_area_2d_area_entered(area):
	if area.is_in_group('purple'):
		colorController.lightDir = randf_range(-20, 20)
		playSound("tone")
		if fadeAway:
			startColorTransitionCharacter(Color(255,255,255,255))
			startColorTransitionSky(Color(255,255,255,255))
		#startColorTransitionSky(colorList[colorController.colorIDX])
		startColorTransitionSky(getRandomColor())
		if colorController.colorIDX < colorList.size() - 1:
			colorController.colorIDX = colorController.colorIDX + 1
		else:
			print('out of size!')
			pass
		#startColorTransitionCharacter(skyList[colorController.skyIDX])
		startColorTransitionCharacter(getRandomColor())
		if colorController.skyIDX < skyList.size() - 1:
			colorController.skyIDX = colorController.skyIDX + 1
		else:
			print('out of size!')
			pass
		area.queue_free()
		print("Turned Purple!")
	if area.is_in_group('red'):
		#if colorController.cubeCount > 5:
			#startColorTransitionCharacter(Color(255,255,255,255))
			#startColorTransitionSky(Color(255,255,255,255))
			#colorController.skyColor = Color(255,255,255,255)
			#colorController.myColor = Color(255,255,255,255)
			#colorController.camZoom = 0.8 
			#velocity.y = JUMP_VELOCITY * 600
			#myShadow.visible = false
			#fadeAway = true
			#playSound("pickup")
			#gravity = 0 
			#area.queue_free()
		#else:
		colorController.cubeCount = colorController.cubeCount + 1
		colorController.camZoom = colorController.camZoom - 0.2
		playSound("pickup")
		gravity = gravity/1.6
		area.queue_free()
	if area.is_in_group('end'):
		colorController.resetGlobals()
		get_tree().reload_current_scene()
		area.queue_free()
	if area.is_in_group('oob'):
		startColorTransitionSky(getRandomColor())
		startColorTransitionCharacter(getRandomColor())
		position = lastPos
		
func resetScale(x : float, y : float):
	myBox.scale.y = lerpf(myBox.scale.y, y, 0.3)
	myBox.scale.x = lerpf(myBox.scale.x, x, 0.3)
	
	
func playSound(soundName: String):
	var newAudioPlayer = AudioStreamPlayer2D.new()
	newAudioPlayer.bus = audioPlayer.bus  # Set the bus if needed
	add_child(newAudioPlayer)  # Add the new AudioSource as a child of the current node

	match soundName:
		"tone":
			var randomPitch = randf_range(0.95, 1.25)
			newAudioPlayer.volume_db = -12
			newAudioPlayer.pitch_scale = randomPitch
			newAudioPlayer.stream = preload("res://audio/tonenewnew.wav")
		"tone2":
			newAudioPlayer.pitch_scale = 1
			newAudioPlayer.stream = preload("res://audio/tone2.wav")
		# Add more cases for other sounds
		"jump":
			var randomPitch = randf_range(0.9, 1.2)
			newAudioPlayer.pitch_scale = randomPitch
			newAudioPlayer.stream = preload("res://audio/lowjump.wav")
		"pickup":
			var randomPitch = randf_range(0.95, 1.12)
			newAudioPlayer.pitch_scale = randomPitch
			newAudioPlayer.volume_db = -16
			newAudioPlayer.stream = preload("res://audio/item.wav")
		"landing":
			newAudioPlayer.stream = preload("res://audio/landing.wav")
	newAudioPlayer.play()

	
func getRandomColor() -> Color:
	# Generate random values for red, green, and blue components
	var randomRed = randf()
	var randomGreen = randf()
	var randomBlue = randf()
	# Create a Color object using the random values
	var randomColor = Color(randomRed, randomGreen, randomBlue)
	return randomColor
