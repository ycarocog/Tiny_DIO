extends Node2D

@export var regeneration_amout:int = 10

var area:Area2D

func _ready()->void:
	$Area.body_entered.connect(on_body_entered)

func on_body_entered(body:Node2D)->void:
	if body.is_in_group("player"):
		var player: Player = body
		player.heal(regeneration_amout)
		player.meat.emit()
		queue_free()
		
