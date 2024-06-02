class_name Player
extends CharacterBody2D


@onready var animation_player:AnimationPlayer = get_node("Animation")
@onready var sprite_player:Sprite2D = get_node("Sprite")
@onready var sword_area:Area2D = get_node("Area_Sword")
@onready var hitbox_area:Area2D = get_node("HitboxArea")
@onready var health_bar:ProgressBar = get_node("Health_ProgressBar")

@export_category("Life")
@export var health:int = 100
@export var max_health:int = 100
@export_category("Scenes")
@export var death_prefabs:PackedScene
@export_category("Movement")
@export var speed:float = 170
@export_category("Sword")
@export var sword_damage:int = 2
@export_category("Ritual")
@export var ritual_damage:int 
@export var ritual_interval:float = 30
@export var ritual_scene:PackedScene

const NUMBER_FOR_DELTA = 100

var is_running:bool = false
var is_attacking:bool = false
var attack_cooldown:float = 0.0
var hitbox_cooldown:float = 0.0
var ritual_cooldown:float = 0.0

signal meat

func _ready()->void:
	GameManager.player_name = self
	meat.connect(func():GameManager.meat_counter +=1)

func _process(delta)->void:
	update_cooldown(delta)
	update_damage(delta)
	update_ritual(delta)
	update_health_bar()

func _physics_process(delta)->void:
	GameManager.player_position = position
	check_attack()
	move(delta)
	size_direction()
	
	
	

func move(delta:float)->void:
	var direction:Vector2 = get_direction() 
	var target_velocity = direction * speed * delta * NUMBER_FOR_DELTA
	velocity = lerp(velocity,target_velocity,0.5)
	move_and_slide()
	var was_running:bool = is_running
	is_running = !target_velocity.is_zero_approx()
	animation(was_running)
	
func get_direction()->Vector2:
	return Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up","down")
	).normalized()

func size_direction()->void:
	if is_attacking == false:
		if velocity.x < 0:
			sprite_player.flip_h = true
		elif velocity.x > 0:
			sprite_player.flip_h = false

func animation(was_run:bool)->void:
	if !is_attacking:
		if was_run != is_running:
			if is_running:
				animation_player.play("run")
			else:
				animation_player.play("idle")

func check_attack()->void:
	if Input.is_action_just_pressed("atack"):
		attack()

func attack()->void:
	if is_attacking:
		return
	animation_player.play("horizontal_attack_1")
	attack_cooldown = 0.6
	is_attacking = true

func update_cooldown(delta:float)->void:
	if is_attacking:
		attack_cooldown -= delta
		if attack_cooldown <= 0:
			is_attacking = false
			is_running = false
			animation_player.play("idle")

func deal_damage_to_enemies()->void:
	var bodies = sword_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var enemy:Enemy = body
			
			var direction_to_enemy = (enemy.position - position).normalized()
			var attack_direction:Vector2 
			if sprite_player.flip_h:
				attack_direction = Vector2.LEFT
			else :
				attack_direction = Vector2.RIGHT
			var dot_product = direction_to_enemy.dot(attack_direction)
			if dot_product >= 0.3:
				enemy.damage(sword_damage)
		
func update_damage(delta:float)->void:
	hitbox_cooldown -= delta
	if hitbox_cooldown > 0:
		return
	
	hitbox_cooldown = 0.5
	
	var bodies = hitbox_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			var damage_body = body.enemy_damage
			damage(damage_body)

func damage(amount:int)->void:
	if health <= 0:
		return
	health -= amount
	
	modulate = Color.RED
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(tween.TRANS_QUINT)
	tween.tween_property(self,"modulate",Color.WHITE,0.3)
	
	if health <= 0:
		die()
		queue_free()
	

func die()->void:
	GameManager.end_game()
	
	if death_prefabs:
		var death_object = death_prefabs.instantiate()
		death_object.position = position
		get_parent().add_child(death_object)

func heal(amount_heal:int)->int:
	health += amount_heal
	if health > max_health:
		health = max_health
	return health

func update_ritual(delta:float)->void:
	if ritual_cooldown > 0:
		ritual_cooldown -= delta
		return
	
	var ritual = ritual_scene.instantiate()
	ritual.damage_amount = ritual_damage
	add_child(ritual)
	ritual_cooldown = ritual_interval

func update_health_bar()->void:
	health_bar.max_value = max_health
	health_bar.value = health
