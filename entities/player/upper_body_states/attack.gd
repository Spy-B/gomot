extends State

@export var comboAttacks: Array[String] = []
@export var damageValue: int = 25

@onready var quit_state_timer: Timer = $"../../Timers/QuitStateTimer"
var timeout: bool = false
var current_attack_index: int = 0


func enter() -> void:
	print("[State] -> Attacking")
	
	parent.runtime_vars.can_fire = false

	current_attack_index = 0
	parent.runtime_vars.attack_queued = false
	timeout = false
	
	if comboAttacks.size() > 0:
		animation.play(comboAttacks[0])
	else:
		super()
	
	quit_state_timer.start()

func process_input(event: InputEvent) -> State:
	if event.is_action_pressed("attack") && !timeout:
		parent.runtime_vars.attack_queued = true
		quit_state_timer.start()
	
	if event.is_action_pressed("shoot") && parent.shootingAbility && !timeout:
		parent.runtime_vars.shoot_queued = true
		quit_state_timer.start()

	# if event.is_action_pressed("jump") && parent.jumpingAbility && parent.runtime_vars.jump_points <= 0 && !timeout:
	# 	if parent.jump_buffer_timer.is_stopped():
	# 		parent.jump_buffer_timer.start()
		
	# 	if !parent.coyote_timer.is_stopped() && parent.runtime_vars.have_coyote:
	# 		parent.runtime_vars.have_coyote = false
	# 		return parent.startJumpingState
	
	return null

func process_frame(_delta: float) -> State:
	if parent.runtime_vars.damaged:
		return parent.damagingState
	
	if parent.runtime_vars.can_fire:
		return parent.shootingState

	return null

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	var movement: float = Input.get_axis("move_left", "move_right") * 20
	
	if movement != 0:
		parent.upper_body_sprite.scale.x = 1 if movement > 0 else -1
	
	parent.velocity.x = movement
	parent.move_and_slide()
	
	
	if timeout:
		if !movement && parent.is_on_floor():
			return parent.idleState
		return parent.runningState
	
	return null


func _on_quit_state_timer_timeout() -> void:
	timeout = true

func _on_animation_player_animation_finished(_anim_name: StringName) -> void:
	if parent.runtime_vars.attack_queued && current_attack_index < comboAttacks.size() - 1:
		current_attack_index += 1
		animation.play(comboAttacks[current_attack_index])
		parent.runtime_vars.attack_queued = false
		quit_state_timer.start()
	
	elif parent.runtime_vars.shoot_queued && current_attack_index < comboAttacks.size() - 1:
		parent.runtime_vars.can_fire = true
		quit_state_timer.stop()

	else:
		timeout = true

func _on_hit_area_body_entered(body: Node2D) -> void:
	if body.is_in_group(parent.enemyGroup):
		body.health -= damageValue
		body.runtime_vars.damaged = true
		#parent.runtime_vars.combo_fight_points += 1
		print("[Enemy] -> [Health]: -", damageValue)
