extends NPCsState

var waiting_time: float
var change_state: bool = false

func enter() -> void:
	print("[Enemy][State]: Wandering")
	super()
	
	parent.status_history.append(self)
	
	change_state = false
	
	randomize()
	waiting_time = randf_range(1, 4)
	
	rgs_timer.wait_time = waiting_time
	rgs_timer.start()
	
	parent.dir *= -1

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = parent.walkSpeed * parent.dir
	sprite.scale.x = abs(sprite.scale.x) * parent.dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return parent.damagingState
	
	if change_state:
		return parent.idleState
	
	if !parent.g_ray_cast.is_colliding():
		return parent.idleState
	
	if parent.w_ray_cast.is_colliding():
		parent.dir *= -1
	
	if parent.player_detected:
		return parent.chasingState
		
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
