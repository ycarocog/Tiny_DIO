extends Node

@export var mob_spawner:MobSpawner
@export var initial_spawn_rate:float = 60.0
@export var spawn_rate_per_minute:float= 30.0
@export var wave_duration:float = 20.0
@export var break_intesity:float = 0.5

var time:float = 0.0

func _process(delta)->void:
	if GameManager.is_game_over:
		return
	time += delta
	
	#Dificuldade Linear
	var spawn_rate = initial_spawn_rate * spawn_rate_per_minute * (time/60.0)
	
	#Sistema de ondas
	var sin_wave = sin(time * TAU)
	var wave_factor = remap(sin_wave,-1.0,1.0,break_intesity,1)
	
	spawn_rate *= wave_factor
	
	#Aplicar dificuldade
	mob_spawner.mobs_per_minutes = spawn_rate
