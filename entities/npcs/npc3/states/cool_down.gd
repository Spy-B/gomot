extends NPCsState

@export_range(0, 10, 0.5) var cooldownPeriod: float = 5.0
@onready var cooldown_period_timer: Timer = $"../../Timers/CooldownPeriodTimer"

func enter() -> void:
	print("[Enemy][State]: Cool Down")
	parent.states_history.append(self)
	
	cooldown_period_timer.wait_time = cooldownPeriod
	cooldown_period_timer.start()

func process_frame(_delta: float) -> NPCsState:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.runtime_vars.player_detected:
		return parent.chasingState
	
	if parent.runtime_vars.cool_down:
		return parent.idleState
	
	return null

func process_physics(_delta: float) -> NPCsState:
	parent.runtime_vars.player_pos = (Global.player.global_position - parent.global_position).normalized()
	
	if parent.runtime_vars.player_pos > Vector2(0, 0):
		parent.dir = 1
	elif parent.runtime_vars.player_pos < Vector2(0, 0):
		parent.dir = -1
	
		parent.move_and_slide()
	else:
		return parent.idleState
	
	return null


func _on_cooldown_period_timer_timeout() -> void:
	parent.player_detector.target_position.x = 250.0
	parent.runtime_vars.cool_down = true
	
	cooldown_period_timer.stop()
