extends NPCsState

var change_state: bool = false

func enter() -> void:
	print("[Enemy][State]: Idle")
	super()
	
	parent.states_history.append(self)
	
	change_state = false

	randomize()
	parent.runtime_vars.waiting_time = randf_range(1, 3)
	get_tree().create_timer(parent.runtime_vars.waiting_time).timeout.connect(func() -> void: change_state = true)

func process_frame(_delta: float) -> NPCsState:
	match parent.NpcType:
		0:
			if parent.runtime_vars.damaged:
				return parent.damagingState
			
			if change_state:
				return parent.wanderingState
			
			if parent.w_ray_cast.is_colliding():
				parent.dir *= -1
			
			if parent.runtime_vars.player_detected:
				return parent.chasingState
		1:
			parent.runtime_vars.player_pos = (Global.player.global_position - parent.global_position).normalized()
			
			if parent.runtime_vars.player_pos > Vector2(0, 0):
				parent.dir = 1
			elif parent.runtime_vars.player_pos < Vector2(0, 0):
				parent.dir = -1
			
			if Global.player.runtime_vars.start_dialogue:
				return parent.talkingState
	
	return null

func process_physics(_delta: float) -> NPCsState:
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.runtime_vars.movement_weight)
	sprite.scale.x = abs(sprite.scale.x) * parent.dir
	
	parent.move_and_slide()
	
	return null