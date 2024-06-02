class_name GameOverUI
extends CanvasLayer

@onready var time_label:Label = get_node("Bottom_Panel/CenterContainer/GridContainer/Time_Label")
@onready var monster_label:Label = get_node("Bottom_Panel/CenterContainer/GridContainer/Amount_Monster")

@export var restart_delay:float = 5.0
var restart_cooldown:float


func _ready():
	time_label.text = GameManager.time_elapsed_string
	monster_label.text = str(GameManager.monster_defeated_counter)
	restart_cooldown = restart_delay

func _process(delta)->void:
	restart_cooldown -= delta
	if restart_cooldown <= 0.0:
		restart_game()

func restart_game()->void:
	GameManager.reset()
	get_tree().reload_current_scene()
