extends State

var attack_type: Array = []

func enter() -> void:
	print("[State] -> Falling")
	super()
	
	parent.runtime_vars.is_falling = true
	
	attack_type.clear()
	parent.runtime_vars.attack_queued = false

func exit() -> void:
	parent.runtime_vars.is_falling = false


func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("jump") && parent.jumpingAbility && parent.runtime_vars.jump_points > 0:
		return parent.jumpingState
	
	
	if event.is_action_pressed("jump") && parent.jumpingAbility && parent.runtime_vars.jump_points <= 0:
		if parent.jump_buffer_timer.is_stopped():
			parent.jump_buffer_timer.start()
		
		if !parent.coyote_timer.is_stopped() && parent.runtime_vars.have_coyote:
			parent.runtime_vars.have_coyote = false
			return parent.startJumpingState
	
	
	if event.is_action_pressed("dash") && parent.dashingAbility:
		if parent.runtime_vars.dash_points > 0:
			return parent.dashingState
	
	
	if event.is_action_pressed("attack"):
		parent.runtime_vars.attack_queued = true
		attack_type.append(1)
	
	elif event.is_action_pressed("shoot"):
		parent.runtime_vars.attack_queued = true
		attack_type.append(2)
	
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.health <= 0:
		return parent.deathState
	
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
	parent.velocity.y += parent.falling_gravity * delta
	
	var movement: float = Input.get_axis("move_left", "move_right") * parent.runSpeed
	
	if movement != 0  && !parent.is_on_floor():
		if movement > 0:
			parent.upper_body_sprite.scale.x = 1
			parent.dash_dir = Vector2.RIGHT
		else:
			parent.upper_body_sprite.scale.x = -1
			parent.dash_dir = Vector2.LEFT
	
	parent.velocity.x = lerp(parent.velocity.x, movement, parent.runtime_vars.movement_weight)
	parent.move_and_slide()
	
	if parent.is_on_floor():
		if parent.runtime_vars.attack_queued && attack_type.has(1):
			parent.runtime_vars.jump_points += 1
			return parent.attackingState
		if parent.runtime_vars.attack_queued && attack_type.has(2):
			parent.runtime_vars.jump_points += 1
			return parent.shootingState
		
		return parent.landingState
	
	return null
