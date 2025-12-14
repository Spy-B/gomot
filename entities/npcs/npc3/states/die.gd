extends NPCsState

func enter() -> void:
	print("[Enemy][State]: Die")
	super()
	
	parent.states_history.append(self)
	
	parent.shoot_ray_cast.enabled = false
	parent.player_detector.enabled = false
	parent.shooting_timer.stop()
	
	Global.saving_slots.slot1.enemies_killed.append(parent.get_rid())
	Global.save_game()

#func process_frame(_delta: float) -> NPCsState:
	# if !parent.is_on_floor():
		# 	parent.velocity.y += gravity * delta
	#return null
