extends NPCsState

func enter() -> void:
	print("[Enemy][State]: Death")
	super()
	
	parent.states_history.append(self)
	
	parent.attacking_ray_cast.enabled = false
	parent.player_detector.enabled = false
	
	Global.saving_slots.slot1.enemies_killed.append(parent.get_rid())
	Global.save_game()

#func process_frame(_delta: float) -> NPCsState:
	#return null
