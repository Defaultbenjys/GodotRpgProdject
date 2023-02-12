extends Node2D

onready var anim_player = $AnimationPlayer

func _ready():
	anim_player.play("RocketCutScene")


func _on_Button_pressed():
	get_tree().change_scene("res://World.tscn")

