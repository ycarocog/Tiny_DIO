extends Node

signal game_over

var meat_counter:int = 0
var time_elapsed:float = 0.0
var time_elapsed_string:String

var player_name: Player
var player_position:Vector2
var is_game_over:bool = false
var monster_defeated_counter:int = 0

func _process(delta)->void:
	time_elapsed += delta
	var time_elapsed_in_second:int = floori(time_elapsed)
	var second:int = time_elapsed_in_second % 60
	var minutes:int = time_elapsed_in_second / 60
	
	time_elapsed_string = "%02d:%02d" % [minutes,second]
	

func end_game()->void:
	if is_game_over:
		return
	is_game_over = true
	game_over.emit()

func reset():
	meat_counter = 0
	time_elapsed = 0
	time_elapsed_string = "00:00"
	monster_defeated_counter = 0
	player_name = null
	player_position = Vector2.ZERO
	is_game_over = false
	for connection in game_over.get_connections():
		game_over.disconnect(connection.callable)
