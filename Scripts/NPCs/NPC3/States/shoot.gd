extends NPCsState


func enter() -> void:
	print("[Enemy][State]: Shooting")
	parent.status_history.append(self)
	
	parent.shooting_timer.wait_time = parent.fireRate
	parent.shooting_timer.start()

func process_input(_event: InputEvent) -> NPCsState:
	return null

func process_frame(_delta: float) -> NPCsState:
	if parent.damaged:
		return parent.damagingState
	
	if !parent.shoot_ray_cast.get_collider() == Global.player && parent.health > 0:
		return parent.idleState
	
	#if parent.ammoInMag <= 0:
		#return reloadingState
	
	return null

func process_physics(delta: float) -> NPCsState:
	if !parent.is_on_floor():
		parent.velocity.y += gravity * delta
	
	parent.velocity.x = lerp(parent.velocity.x, 0.0, parent.movementWeight)
	
	parent.move_and_slide()
	
	return null

func _on_shooting_timer_timeout() -> void:
	if parent.shoot_ray_cast.get_collider() == Global.player:
		animation.play("Shooting")
		
		var bullet: Area2D = parent.bulletScene.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
		bullet.global_position = gun_barrel.global_position
		bullet.global_rotation = gun_barrel.global_rotation
		bullet.dir = parent.dir
		
		get_parent().add_child(bullet)
