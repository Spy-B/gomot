extends NPCsState

@export_range(0, 10, 0.5) var cooldownPeriod: float = 5.0
@onready var cooldown_period_timer: Timer = $"../../Timers/CooldownPeriodTimer"

func enter() -> void:
	print("[Enemy][State]: Chasing")
	super()
	
	parent.states_history.append(self)
	
	cooldown_period_timer.wait_time = cooldownPeriod

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.runtime_vars.damaged:
		return parent.damagingState

	if parent.flying_altitud.global_transform.origin.distance_to(parent.flying_altitud.get_collision_point()) > parent.flying_altitud.target_position.y + 20.0:
		parent.velocity.y = parent.flightSpeed
	elif parent.flying_altitud.global_transform.origin.distance_to(parent.flying_altitud.get_collision_point()) < parent.flying_altitud.target_position.y - 20.0:
		parent.velocity.y = parent.flightSpeed * -1
	else:
		parent.velocity.y = 0
	
	parent.shoot_ray_cast.look_at(Global.player.global_position)
	gun_barrel.look_at(Global.player.global_position)
	
	if parent.shoot_ray_cast.get_collider() == Global.player:
		return parent.shootingState
	
	if !parent.runtime_vars.player_detected: 
		return parent.cooldownState
	
	return null

func process_physics(_delta: float) -> NPCsState:
	parent.runtime_vars.player_pos = (Global.player.global_position - parent.global_position).normalized()
	
	if parent.runtime_vars.player_pos > Vector2(0, 0):
		parent.dir = 1
	elif parent.runtime_vars.player_pos < Vector2(0, 0):
		parent.dir = -1
	
	parent.velocity.x = parent.flightSpeed * parent.dir
	sprite.scale.x = abs(sprite.scale.x) * parent.dir
	
	parent.move_and_slide()
	
	return null
