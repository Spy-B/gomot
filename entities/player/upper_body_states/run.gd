extends State



func enter() -> void:
	print("[State] -> Running")
	super()

func process_input(event: InputEvent) -> State:
	if parent.is_on_floor():
		if event.is_action_pressed("jump") && parent.jumpingAbility && parent.runtime_vars.jump_points > 0:
			return parent.startJumpingState
		
		if event.is_action_pressed("dash") && parent.dashingAbility:
			if parent.runtime_vars.dash_points > 0:
				return parent.dashingState
		
		if event.is_action_pressed("attack") && parent.attackingAbility:
			return parent.attackingState
		
		if event.is_action_pressed("shoot") && parent.shootingAbility:
			return parent.shootingState
		
		if event.is_action_pressed("reload"):
			return parent.reloadingState
	
	return null

func process_frame(_delta: float) -> State:
	#if parent.runtime_vars.is_floating:
		#parent.runSpeed = 80
	
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.runtime_vars.npc_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.talkingState
	
	elif parent.runtime_vars.interaction_detected:
		parent.ui.interact_key.visible = true
		if Input.is_action_just_pressed("interact"):
			return parent.interactState
	
	else:
		parent.ui.interact_key.visible = false
	
	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if !movement:
		return parent.idleState
	
	#parent.upper_body_sprite.flip_h = movement > 0
	
	if movement > 0:
		parent.upper_body_sprite.scale.x = 1
		parent.dash_dir = Vector2.RIGHT
	else:
		parent.upper_body_sprite.scale.x = -1
		parent.dash_dir = Vector2.LEFT
	
	if movement >= parent.runSpeed:
		parent.velocity.x = min(parent.velocity.x + parent.acceleration, movement)
	else:
		parent.velocity.x = max(parent.velocity.x - parent.acceleration, movement)
	
	parent.move_and_slide()
	
	if !parent.is_on_floor():
		parent.coyote_timer.start()
		return parent.fallingState
	
	return null
