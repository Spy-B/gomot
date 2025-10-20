extends NPCsState

var damaging_anime_finished: bool = false
var previous_state: NPCsState

@onready var damaging_timer: Timer = $"../../Timers/DamagingTimer"

func enter() -> void:
	super()
	print("[Enemy][State]: Damage")
	
	parent.runtime_vars.damaged = false
	
	parent.sprite.material.set_shader_parameter("flashValue", 1.0)
	damaging_timer.start()
	
	parent.runtime_vars.health -= parent.runtime_vars.damage_value
	parent.health_bar.value = parent.runtime_vars.health
	
	previous_state = parent.states_history.back()
	
	if previous_state == parent.idleState || previous_state == parent.wanderingState:
		previous_state = parent.chasingState

func process_frame(_delta: float) -> NPCsState:
	if damaging_anime_finished && parent.runtime_vars.health > 0:
		damaging_anime_finished = false
		return previous_state
	
	elif damaging_anime_finished && parent.runtime_vars.health <= 0:
		damaging_anime_finished = false
		return parent.deathState
	
	return null


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Damaging":
		damaging_anime_finished = true


func _on_damaging_timer_timeout() -> void:
	parent.sprite.material.set_shader_parameter("flashValue", 0.0)
	damaging_anime_finished = true
