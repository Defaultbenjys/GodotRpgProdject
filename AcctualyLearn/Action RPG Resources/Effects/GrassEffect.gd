extends Node2D

onready var animatedsprite = $AnimatedSprite

func _ready():
	animatedsprite.frame = 0
	animatedsprite.play("Animate")


func _on_AnimatedSprite_animation_finished():
	queue_free()
