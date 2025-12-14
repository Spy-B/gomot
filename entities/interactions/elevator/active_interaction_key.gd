extends StaticBody2D

# its actually biend used by "elevator.gd"
@warning_ignore("unused_signal")
signal declare_interaction
@warning_ignore("unused_signal")
signal undeclare_interaction

var is_interacting: bool = false

#func _ready() -> void:
	#pass
