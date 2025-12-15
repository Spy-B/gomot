extends NPCsState

var change_state: bool = false

func enter() -> void:
	print("[Enemy][State]: Wandering")
	super()
	
	parent.states_history.append(self)
	
	change_state = false
	
	randomize()
	parent.runtime_vars.waiting_time = randf_range(1, 4)
	get_tree().create_timer(parent.runtime_vars.waiting_time).timeout.connect(func() -> void: change_state = true)
	
	parent.dir *= -1

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

	if change_state:
		return parent.idleState
	
	if parent.w_ray_cast.is_colliding():
		parent.dir *= -1
	
	if parent.runtime_vars.player_detected:
		return parent.chasingState
		
	return null

func process_physics(_delta: float) -> NPCsState:
	parent.velocity.x = parent.flightSpeed * parent.dir
	sprite.scale.x = abs(sprite.scale.x) * parent.dir
	
	parent.move_and_slide()
	
	return null
