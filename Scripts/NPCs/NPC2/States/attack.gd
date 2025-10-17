extends NPCsState

func enter() -> void:
	super()
	print("[Enemy][State]: Attacking")
	parent.states_history.append(self)
	
	parent.attacking_timer.wait_time = parent.attackRate
	parent.attacking_timer.start()

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return parent.damagingState
	
	if !parent.attacking_ray_cast.get_collider() == Global.player && parent.health > 0:
		parent.player_detected = false
		return parent.idleState
	
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
	parent.move_and_slide()
	
	return null


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body == Global.player:
		body.health -= parent.hitDamage
		body.camera.shake(0.1, Vector2(2.0, 2.0))


func _on_attacking_timer_timeout() -> void:
	enter()
