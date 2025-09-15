extends NPCsState

@export_range(0, 10, 0.5) var cooldownPeriod: float = 5.0
@onready var cooldown_period_timer: Timer = $"../../Timers/CooldownPeriodTimer"

func enter() -> void:
	print("[Enemy][State]: Chasing")
	super()
	
	parent.status_history.append(self)
	
	cooldown_period_timer.wait_time = cooldownPeriod
	
	parent.player_detector.target_position.x = 300.0

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.player_pos = (Global.player.global_position - parent.global_position).normalized()
	
	if parent.player_pos > Vector2(0, 0):
		parent.dir = 1
	elif parent.player_pos < Vector2(0, 0):
		parent.dir = -1
	
	parent.velocity.x = parent.walkSpeed * parent.dir
	sprite.scale.x = abs(sprite.scale.x) * parent.dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return parent.damagingState
	
	if parent.shoot_ray_cast.get_collider() == Global.player:
		return parent.shootingState
	
	if !parent.player_detected: 
		return parent.cooldownState
	
	return null
