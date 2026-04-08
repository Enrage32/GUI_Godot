extends CharacterBody2D

class_name Slime # a player can acces us later

const SPEED = 50

@onready var left_cast: RayCast2D = $Left_cast
@onready var right_cast: RayCast2D = $Right_cast
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var killzone_collision: CollisionShape2D = $Killzone/CollisionShape2D

var direction = 1
var died = false

func _physics_process(delta: float) -> void:
	
	if died:
		animated_sprite.play("die")
		killzone_collision.disabled = true
		return
		
	
	if right_cast.is_colliding():
		direction = -1
		animated_sprite.flip_h = true
	elif left_cast.is_colliding():
		direction = 1
		animated_sprite.flip_h = false
	
	position.x += direction * SPEED * delta

func take_damage():
	died = true

func _on_animated_sprite_2d_animation_finished() -> void:
	var finished_animation = animated_sprite.animation
	if finished_animation == "die":
		queue_free()
	
