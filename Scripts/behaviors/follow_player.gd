extends Node

@export var speed:float = 2.0
var sprite:AnimatedSprite2D

var enemy:Enemy

func _ready()->void:
	enemy = get_parent()
	sprite = enemy.get_node("Animation_Sprite")

func _physics_process(_delta:float)->void:
	if GameManager.is_game_over:
		return
	var player_position:Vector2 = GameManager.player_position
	var difference = player_position - enemy.position
	var input_vector = difference.normalized()
	
	enemy.velocity = input_vector * speed * 100 
	enemy.move_and_slide()
	rotate_direction()

func rotate_direction()->void:
	if enemy.velocity.x < 0:
		sprite.flip_h = true
	elif  enemy.velocity.x > 0:
		sprite.flip_h = false
