class_name Monkey extends CharacterBody2D

enum STATE {
	IDLE,
	WAITING,
	TALKING,
	MOVING
}

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var timer: Timer = %Timer
var state: STATE = STATE.IDLE
var direction: Vector2 = Vector2.ZERO

func _ready() -> void:
	timer.timeout.connect(update_state)
	animated_sprite_2d.frame = randi() % 10
	if randf() > 0.5:
		animated_sprite_2d.flip_h = true
	idle()
	

func update_state() -> void:
	if state == STATE.IDLE:
		if randi() % 4 == 0:
			move()
		elif randi() % 20 == 0:
			talk()
		else:
			timer.start(randf_range(0.8, 1.2))
	else:
		idle()

func _physics_process(_delta):
	if state == STATE.MOVING:
		velocity = direction * 100
		move_and_slide()
			
func move():
	state = STATE.MOVING
	var angle: int = randi() % 360
	direction = Vector2(cos(angle / (2 * PI)), sin(angle / (2 * PI))) * 150
	direction = direction.normalized()
	if direction.x > 0:
		animated_sprite_2d.flip_h = true
	else:
		animated_sprite_2d.flip_h = false
	animated_sprite_2d.play("walk")

	timer.start(randf_range(0.8, 1.2))
	
	
func idle():
	state = STATE.IDLE
	animated_sprite_2d.play("idle")
	update_state()

func talk():
	EventBus.moonkey_talked.emit()
	if animated_sprite_2d.flip_h:
		%BubbleSprite.flip_h = true
		%BubbleSprite.position.x = 54
	else:
		%BubbleSprite.position.x = -54
		
	%BubbleSprite.play("default")
