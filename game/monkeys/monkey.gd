class_name Monkey extends CharacterBody2D

enum STATE {
	IDLE,
	WAITING,
	TALKING,
	MOVING,
	HYPED
}

@onready var animated_sprite_2d: AnimatedSprite2D = %AnimatedSprite2D
@onready var timer: Timer = %Timer
var state: STATE = STATE.IDLE
var direction: Vector2 = Vector2.ZERO

const base_scale: float = 1.0
const base_speed_scale: float = 1.0

var evol_speed: float = base_speed_scale

@export var evol_prob: float = 0.2
@export var evol_amount: float = 0.05

func _ready() -> void:
	timer.timeout.connect(update_state)
	animated_sprite_2d.frame = randi() % 10
	if randf() > 0.5:
		animated_sprite_2d.flip_h = true
	idle()
	EventBus.round_won.connect(hypeOnCorrect)
	EventBus.button_pressed_error.connect(booOnWrong)
	EventBus.game_won.connect(activate_hype_mode)
	EventBus.game_started.connect(reset_state)
	
func reset_state():
	scale = Vector2.ONE * base_scale
	evol_speed = base_speed_scale
	state = STATE.IDLE
	
func _evolve():
	if randf() < evol_prob:
		var has_evolved: bool = false
		$AnimationPlayer.play("evolving")
		if randi()%2:
			scale += Vector2.ONE * evol_amount
			has_evolved = true
		if randi()%2:
			evol_speed += evol_amount
			has_evolved = true
		
		if not has_evolved:
			scale += Vector2.ONE * evol_amount
			evol_speed += evol_amount
			
	
func activate_hype_mode():
	state = STATE.HYPED

func hypeOnCorrect() -> void:
	_evolve()
	if randf() > 0.1:
		EventBus.moonkey_hype.emit()
		%HypeParticules.emitting = true
		
func booOnWrong() -> void:
	if randf() > 0.1:
		EventBus.moonkey_boo.emit()

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
		velocity = direction * 2.0 * evol_speed
		move_and_collide(velocity)
	elif state == STATE.HYPED:
		if randf() > 0.1:
			#EventBus.moonkey_hype.emit()
			%HypeParticules.emitting = true
		
			
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
	timer.start(randf_range(0.8, 1.2))
