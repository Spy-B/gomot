extends Area2D

var motion: Vector2 = Vector2.ZERO
var dir: int = 1
var shooter: CharacterBody2D = null


@export var damageValue: int = 15
@export var target: String

@export var speed: int = 1000
@export_range(1.0, 10.0, 0.5) var bulletLifeTime: float = 1.0
@export_range(1.0, 10.0, 0.5) var timeScale: float = 1.0

@export var followLvlTimeScale: bool = false
@export var followPlayerTimeScale: bool = false


@onready var arrow_sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer


func _ready() -> void:
	motion = Vector2(speed, 0).rotated(rotation)
	
	timer.wait_time = bulletLifeTime
	timer.start()

func _physics_process(delta: float) -> void:
	await get_tree().create_timer(0.35).timeout
	position += motion * delta
	arrow_sprite.visible = true


func _on_body_entered(body: Node2D) -> void:
	if body == shooter:
		return
	
	if body.is_in_group(target):
		body.health -= damageValue
		body.runtime_vars.damaged = true
		print("[Enemy] -> [Health]: -", damageValue)
		#shooter.runtime_vars.combo_fight_points += 1
		
		
		if !body.runtime_vars.player_detected:
			body.runtime_vars.player_detected = true
			body.runtime_vars.cool_down = false
	
	queue_free()


func _on_timer_timeout() -> void:
	queue_free()
