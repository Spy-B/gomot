extends NPCsState

var change_state: bool = false

func enter() -> void:
	print("[Enemy][State]: Idle")
	super()
	
	parent.status_history.append(self)
	
	change_state = false

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	sprite.scale.x = abs(sprite.scale.x) * parent.dir
	
	parent.move_and_slide()
	
	return null

func process_frame(_delta: float) -> NPCsState:
	match parent.NpcType:
		0:
			if parent.damaged:
				return parent.damagingState
			
			if !parent.g_ray_cast.is_colliding() || change_state:
				return parent.wanderingState
			
			if parent.w_ray_cast.is_colliding():
				parent.dir *= -1
			
			if parent.player_detected:
				return parent.chasingState
		1:
			parent.player_pos = (Global.player.global_position - parent.global_position).normalized()
			
			if parent.player_pos > Vector2(0, 0):
				parent.dir = 1
			elif parent.player_pos < Vector2(0, 0):
				parent.dir = -1
			
			if Global.player.runtime_vars.start_dialogue:
				return parent.talkingState
	
	return null

func _on_rgs_timer_timeout() -> void:
	change_state = true
