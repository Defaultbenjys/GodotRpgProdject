extends KinematicBody2D

export var Acceleration = 500
export var Max_Speed = 150
export var Friction = 500
export var Roll_Speed = 220

var velocity = Vector2.ZERO
var state = MOVE
var roll_vector = Vector2.LEFT

enum{
	MOVE,
	ROLL,
	ATTACK,
	BENJY
}
onready var animation_player = $AnimationPlayer
onready var animation_tree = $AnimationTree
onready var animation_state = animation_tree.get("parameters/playback")
onready var swordHitbox = $HitBoxPivot/SwordHitBox

func _ready():
	animation_tree.active = true
	swordHitbox.knockback_vector = roll_vector

func _physics_process(delta):
	match state:
		MOVE:
			move_state(delta)
		ROLL:
			roll_state(delta)
		ATTACK:
			attack_state(delta)
		BENJY:
			benjy_state(delta)

func move_state(delta):
	var input_vector = Vector2.ZERO
	input_vector.x = Input.get_action_strength("Walk_Right") - Input.get_action_strength("Walk_Left")
	input_vector.y = Input.get_action_strength("Walk_Back") - Input.get_action_strength("Walk_Forward")
	input_vector = input_vector.normalized()
	if input_vector != Vector2.ZERO:
		roll_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		swordHitbox.knockback_vector = input_vector
		animation_tree.set("parameters/Idle/blend_position", input_vector)
		animation_tree.set("parameters/Run/blend_position", input_vector)
		animation_tree.set("parameters/Attack/blend_position", input_vector)
		animation_tree.set("parameters/Roll/blend_position", input_vector)
		animation_state.travel("Run")
		velocity = velocity.move_toward(input_vector * Max_Speed, Acceleration * delta)
	else:
		animation_state.travel("Idle")
		velocity = velocity.move_toward(Vector2.ZERO, Friction * delta)
	
	if Input.is_action_just_pressed("Roll"):
		state = ROLL
	
	if Input.is_action_just_pressed("attack"):
		state = ATTACK
	
	move()

func roll_state(delta):
	velocity = roll_vector * Roll_Speed
	animation_state.travel("Roll")
	move()

func attack_state(delta):
	animation_state.travel("Attack")
	velocity = Vector2.ZERO

func benjy_state(delta):
	pass

func roll_animation_finished():
	state = MOVE
	velocity = velocity * 0.8


func move():
	velocity = move_and_slide(velocity)

func attack_animation_finished():
	state = MOVE
