extends Area2D

signal hit

@onready var joystick: TouchScreenButton = $CanvasLayer/Joystick
@export var speed = 400
var screen_size
var velocity = Vector2.ZERO

func _ready():
	screen_size = get_viewport_rect().size
#	hide()


func _physics_process(delta: float) -> void:
	velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
		
	if Input.is_action_pressed("move_left"):
		velocity.x -= 1
		
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
		
	if Input.is_action_pressed("move_up"):
		velocity.y -= 1
	
	# Get joystick direction
	var joystick_direction = $CanvasLayer/Joystick.get_joystick_dir()
	if joystick_direction != Vector2.ZERO:
		velocity = joystick_direction
	#velocity = direction * speed
		
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
		
		
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = velocity.x < 0
		
	elif velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = velocity.y > 0
		
	

func _on_body_entered(body):
	hide()
	hit.emit()
	$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false
	
#func _physics_process(delta: float) -> void:
	#var direction = $CanvasLayer/Joystick.get_joystick_dir()
	#velocity = direction * speed
	#move_and_slide()

