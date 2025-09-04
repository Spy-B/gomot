extends Node2D

@onready var timer: Timer = $Timer
@onready var particle: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	timer.wait_time = particle.lifetime
	timer.start()

func _on_Timer_timeout() -> void:
	queue_free()
