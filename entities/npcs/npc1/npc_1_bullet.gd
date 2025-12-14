extends Area2D

var motion: Vector2 = Vector2.ZERO
var dir: int = 1
var shooter: CharacterBody2D = null


@export var damageValue: int = 15
# @export var target: String

@export var speed: int = 1000
@export_range(1.0, 10.0, 0.5) var bulletLifeTime: float = 1.0
@export_range(1.0, 10.0, 0.5) var timeScale: float = 1.0

@export var followLvlTimeScale: bool = false
@export var followPlayerTimeScale: bool = false


@onready var timer: Timer = $Timer


func _ready() -> void:
	motion = Vector2(speed, 0).rotated(rotation)
	
	timer.wait_time = bulletLifeTime
	timer.start()

func _physics_process(delta: float) -> void:
	if followLvlTimeScale:
		timeScale = Global.timeScale
	elif followLvlTimeScale:
		timeScale = shooter.bulletTimeScale
	
	position += motion * delta # * timeScale

func _on_Bullet_body_entered(body: Node2D) -> void:
	if body == Global.player:
		if body.runtime_vars.just_respawn:
			return
		
		body.health -= damageValue
		body.runtime_vars.damaged = true
		body.camera.shake(0.1, Vector2(2.0, 2.0))
	
	queue_free()


func _on_Timer_timeout() -> void:
	queue_free()
