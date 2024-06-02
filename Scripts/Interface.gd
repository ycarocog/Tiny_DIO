extends CanvasLayer

@onready var timer_label:Label = get_node("Timer_Label")
@onready var meat_label:Label = get_node("Panel/Meat_Amout")


func _process(delta)->void:
	timer_label.text = GameManager.time_elapsed_string
	meat_label.text = str(GameManager.meat_counter)
