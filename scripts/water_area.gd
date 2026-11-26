extends Area3D


@onready var collision_shape: CollisionShape3D = $CollisionShape3D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


# физическое тело вошло в воду
func _on_body_entered(body: Node3D) -> void:
	if body.has_method("enter_water"):
		# Если существует, вызываем его и передаём высоту поверхности воды
		body.enter_water(get_water_surface_y())
		

# физическое тело покинуло воду
func _on_body_exited(body: Node3D) -> void:
	if body.has_method("exit_water"):
		body.exit_water()
		

func get_water_surface_y() -> float:
	var box_shape := collision_shape.shape as BoxShape3D
	
	if box_shape == null:
		return global_position.y

	return global_position.y + box_shape.size.y * 0.5
