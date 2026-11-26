extends RigidBody3D


@export var buoyancy_strength: float = 18.0   # сила выталкивающая поплывок вверх
@export var submerged_depth: float = 0.25     # глубина, на которой сила достигает максимума
@export var water_linear_damp: float = 4.0    # сопротивление воды движению
@export var water_angular_damp: float = 3.0   # сопротивление вращению

var is_in_water: bool = false
var water_surface_y: float = 0.0

var default_linear_damp: float
var defaul_angular_damp: float 


func _ready() -> void:
	default_linear_damp = linear_damp
	defaul_angular_damp = angular_damp


func _physics_process(delta: float) -> void:
	if not is_in_water:
		return
	
	var depth := water_surface_y - global_position.y
	
	if depth <= 0.0:
		return
		
	var submerged_amount := clampf(depth / submerged_depth, 0.0, 1.0)
	apply_central_force(Vector3.UP * buoyancy_strength * submerged_amount)
	
	
func enter_water(surface_y: float) -> void:
	is_in_water = true
	water_surface_y = surface_y
	
	linear_damp = water_linear_damp
	angular_damp = water_angular_damp
	

func exit_water() -> void:
	is_in_water = false
	
	linear_damp = default_linear_damp
	angular_damp = defaul_angular_damp
