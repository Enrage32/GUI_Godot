extends CharacterBody2D

const SPEED = 200
const JUMP_VELOCITY = -350

@onready var animated_sprite: AnimatedSprite2D = $Pivot/AnimatedSprite2D
@onready var pivot: Node2D = $Pivot
@onready var collision_hitbox: CollisionShape2D = $Pivot/Hitbox/CollisionShape2D
@onready var attack_timer: Timer = $AttackTimer
@onready var coyote_jump: Timer = $CoyoteJump


var health = 3
var spawn_position: Vector2
var getting_hit = false
var attacking = false
var emeralds = 0

signal health_down(health)
signal collect_emerald(emeralds)


func _ready() -> void:
	spawn_position = position
	health_down.emit(health)
	collect_emerald.emit(emeralds)

func get_hit():
	getting_hit = true
	health -= 1

func respawn():
	if health > 0:
		position = spawn_position
		getting_hit = false
		health_down.emit(health)
	else:
		get_tree().reload_current_scene()

func pick_emerald():
	emeralds += 1
	collect_emerald.emit(emeralds)

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if getting_hit:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("get_hit")
		move_and_slide()
		return


	if Input.is_action_just_pressed("attack") and attack_timer.is_stopped():
		attacking = true

	if attacking:
		if is_on_floor():
			velocity.x = move_toward(velocity.x, 0, SPEED)
		animated_sprite.play("attack")
		collision_hitbox.disabled = false
		move_and_slide()
		return

	if Input.is_action_just_pressed("jump") and (is_on_floor() or !coyote_jump.is_stopped()):
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("move_left", "move_right")

	if direction != 0:
		pivot.scale.x = direction

	if not is_on_floor():
		animated_sprite.play("jump")
	elif direction != 0:
		animated_sprite.play("run")
	else:
		animated_sprite.play("idle")


	if direction:
		velocity.x = SPEED * direction
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	var on_floor = is_on_floor()

	move_and_slide()

	if on_floor and !is_on_floor():
		coyote_jump.start()


func _on_animated_sprite_2d_animation_finished() -> void:
	var finished_animation = animated_sprite.animation
	if finished_animation == "get_hit":
		respawn()
	elif finished_animation == "attack":
		attacking = false
		attack_timer.start()
		collision_hitbox.disabled = true



func _on_hitbox_area_entered(area: Area2D) -> void:
	var body = area.get_parent()
	if body is Slime: #if it's a mob
		body.take_damage()
