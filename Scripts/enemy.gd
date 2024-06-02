class_name Enemy
extends CharacterBody2D

@onready var damage_maker:Marker2D = get_node("Damage_Marker")

@export_category("Life")
@export var health:int = 10
@export var death_prefabs:PackedScene
@export var enemy_damage:float = 2

@export_category("Drops")
@export var drop_chances:float = 0.1
@export var drop_items:Array[PackedScene]
@export var chances:Array[float]


var damage_digit:PackedScene


func _ready():
	damage_digit = preload("res://Scenes/damage_digit.tscn")

func damage(amount:int)->void:
	health -= amount
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	var damage_scene = damage_digit.instantiate()
	damage_scene.value = amount
	if damage_maker:
		damage_scene.global_position = damage_maker.global_position
	get_parent().add_child(damage_scene)
	
	if health <= 0:
		GameManager.monster_defeated_counter += 1
		die()
		queue_free()
	

func die()->void:
	if death_prefabs:
		var death_object = death_prefabs.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)
		
	if randf() <= drop_chances:
		drop()

func drop_item()->PackedScene:
	if drop_items.size() == 1:
		return drop_items[0]
	
	var max_chance:float = 0.0
	for drop_chance in drop_chances:
		max_chance += drop_chance
	
	var random_value = randf() * max_chance
	
	var needle:float = 0.0
	for i in drop_items.size():
		var item = drop_items[i]
		var chance = chances[i] if i < chances.size() else 1
		if random_value <= chance + needle:
			return item
		needle += chance
	return drop_items[0]

func drop()->void:
	var template = drop_item()
	var item_spawn = template.instantiate()
	item_spawn.position = position
	get_parent().add_child(item_spawn)
