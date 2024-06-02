extends Enemy

@onready var bomb_area:Area2D = get_node("Bomb_detection")
@onready var animation_enemy:AnimatedSprite2D = get_node("Animation_Sprite")
@onready var damage_marker:Marker2D = get_node("Damage_Marker")

var attack:bool = true
var player:CharacterBody2D


func _physics_process(_delta)->void:
	check_bomb()

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
		GameManager.monster_defeated_counter +=1
		die()
		queue_free()
	

func die()->void:
	if death_prefabs:
		var death_object = death_prefabs.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)

func check_bomb()->void:
	var bombs = bomb_area.get_overlapping_bodies()
	for bomb in bombs:
		if  bomb.is_in_group("player"):
			$Animation_Sprite.play("explosion")
			player = bomb
			


func _on_animation_sprite_animation_finished():
	if player != null:
		attack_player(player)
	damage(5)

func attack_player(player_bomb:CharacterBody2D)->void:
	player_bomb.damage(enemy_damage)
	
