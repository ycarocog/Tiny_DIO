extends Node2D

@export var damage_amount:int = 5

@onready var area_detetection:Area2D = get_node("Detetection_Area")

func deal_damage()->void:
	var bodies = area_detetection.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy = body
			enemy.damage(damage_amount)
