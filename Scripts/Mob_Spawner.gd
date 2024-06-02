class_name MobSpawner
extends Node2D

@export var list_enemy:Array[PackedScene]
@export var mobs_per_minutes:float = 60

@onready var path_follow_2d:PathFollow2D = %PathFollow
var cooldown_spawn:float = 0.0


func _process(delta):
	if GameManager.is_game_over:
		return
	spawn_enemy(delta)

func get_point()->Vector2:
	path_follow_2d.progress_ratio = randf()
	return path_follow_2d.global_position

func spawn_enemy(delta:float)->void:
	var intervalo = 60/ mobs_per_minutes
	if cooldown_spawn > 0:
		cooldown_spawn -= delta
		return
	
	var point = get_point()
	var world_state = get_world_2d().direct_space_state
	var parameters = PhysicsPointQueryParameters2D.new()
	parameters.position = point
	parameters.collision_mask  = 0b1000
	var result:Array = world_state.intersect_point(parameters, 1)
	if !result.is_empty():
		return
	
	var enemy_number = randi_range(0, list_enemy.size() - 1)
	var enemy:PackedScene = list_enemy[enemy_number]
	var spawn_enemies:Enemy = enemy.instantiate()
	spawn_enemies.global_position = point
	get_parent().add_child(spawn_enemies)
	cooldown_spawn = intervalo
