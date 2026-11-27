extends RigidBody3D
class_name Bobber

signal bite_started    # событие, о котором позже сможет узнать игрок

# Состояния рыбалки
enum FishingState {
	FLYING,     # поплавок летит или находится вне воды
	WAITING,    # находится в воде и ждёт рыбу
	BITE        # рыба клюнула
}


@export var buoyancy_strength: float = 18.0   # сила выталкивающая поплывок вверх
@export var submerged_depth: float = 0.25     # глубина, на которой сила достигает максимума
@export var water_linear_damp: float = 4.0    # сопротивление воды движению
@export var water_angular_damp: float = 3.0   # сопротивление вращению
# Настройки рыбалки
@export var min_bite_delay: float = 2.0
@export var max_bite_delay: float = 6.0
@export var bite_pull_speed: float = 2.5
@export var bite_window_duration: float = 1.5   # Длительность поклевки
# Леска
@export var line_stiffness: float = 20.0       # насколько сильно леска возвращает поплавок
@export var line_damping: float = 3.0          # гашение колебаний
@export var minimum_line_length: float = 1.5

@onready var bite_timer: Timer = $BiteTimer
@onready var line_visual: MeshInstance3D = $LineVisual


var line_anchor: Node3D                 # точка, к которой привязана леска
var line_data: LineData                 # экипированный вид лески
var released_line_length: float = 0.0   # выпущенная длина
var current_tension: float = 0.0        # текущее натяжение

var is_in_water: bool = false
var water_surface_y: float = 0.0	

var default_linear_damp: float
var defaul_angular_damp: float 

var fishing_state: FishingState = FishingState.FLYING

var line_mesh: ImmediateMesh
var line_material: StandardMaterial3D


func _ready() -> void:
	default_linear_damp = linear_damp
	defaul_angular_damp = angular_damp
	bite_timer.timeout.connect(_on_bite_timer_timeout)
	setup_line_visual()


func _process(delta: float) -> void:
	update_line_visual()


func _physics_process(delta: float) -> void:
	apply_buoyancy()
	apply_line_tension()
	
	
func enter_water(surface_y: float) -> void:
	is_in_water = true
	water_surface_y = surface_y
	
	linear_damp = water_linear_damp
	angular_damp = water_angular_damp
	
	# Управляем рыбалкой
	fishing_state = FishingState.WAITING
	var bite_delay = randf_range(min_bite_delay, max_bite_delay)
	bite_timer.start(bite_delay)
	

func exit_water() -> void:
	is_in_water = false
	
	linear_damp = default_linear_damp
	angular_damp = defaul_angular_damp
	
	# Выключаем рыбалку
	bite_timer.stop()
	fishing_state = FishingState.FLYING
	
	
# Обработчик таймера
func _on_bite_timer_timeout() -> void:
	match fishing_state:
		FishingState.WAITING:
			start_bite()
		FishingState.BITE:
			miss_bite()


# Функция поклевки
func start_bite() -> void:
	if not is_in_water:
		return
	fishing_state = FishingState.BITE
	sleeping = false
	apply_central_impulse(Vector3.DOWN * bite_pull_speed)
	
	bite_started.emit()
	print("Поклевка!")
	bite_timer.start(bite_window_duration)


# Функция неудачной подсечки рыбы
func miss_bite() -> void:
	print("Рыба сорвалась!")
	fishing_state = FishingState.WAITING
	
	var next_bite_delay := randf_range(min_bite_delay, max_bite_delay)
	bite_timer.start(next_bite_delay)
	

# Проверка - клюет ли рыба прямо сейчас
func try_hook() -> bool:
	if fishing_state != FishingState.BITE:
		return false
	bite_timer.stop()
	print("Успешная подсечка")
	return true


# Установка лески
func setup_line(anchor: Node3D, equipped_line: LineData, requested_length: float) -> void:
	line_anchor = anchor
	line_data = equipped_line
	released_line_length = minf(requested_length, equipped_line.length_m)
	

# Функция плавучести
func apply_buoyancy() -> void:
	if not is_in_water:
		return
	var depth := water_surface_y - global_position.y
	if depth <= 0.0:
		return
	var submerged_amount := clampf(depth / submerged_depth, 0.0, 1.0)
	apply_central_force(Vector3.UP * buoyancy_strength * submerged_amount)


# Функция натяжения нити
func apply_line_tension() -> void:
	if line_anchor == null:
		current_tension = 0.0
		return
	var distance := global_position.distance_to(line_anchor.global_position)
	var stretch := distance - released_line_length
	if stretch <= 0.0:
		current_tension = 0.0
		return
	var pull_direction := global_position.direction_to(line_anchor.global_position)
	current_tension = stretch * line_stiffness
	var spring_force := (pull_direction * current_tension)
	var radial_velocity := linear_velocity.project(pull_direction)
	var damping_force := (-radial_velocity * line_damping)
	apply_central_force(spring_force + damping_force)


func reel_in(amount: float) -> void:
	released_line_length = maxf(minimum_line_length, released_line_length - amount)


# Отображение лески
func setup_line_visual() -> void:
	line_mesh = ImmediateMesh.new()
	line_visual.mesh = line_mesh
	
	line_material = StandardMaterial3D.new()
	line_material.shading_mode = (BaseMaterial3D.SHADING_MODE_UNSHADED)
	line_material.albedo_color = Color(0.85, 0.9, 0.85, 1.0)
	line_visual.hide()


# Обновление лески
func update_line_visual() -> void:
	if line_anchor == null:
		line_visual.hide()
		return
	line_visual.show()
	line_mesh.clear_surfaces()
	line_mesh.surface_begin(Mesh.PRIMITIVE_LINES, line_material)
	
	var bobber_position := line_visual.to_local(global_position)
	var anchor_position := line_visual.to_local(line_anchor.global_position)
	line_mesh.surface_add_vertex(bobber_position)
	line_mesh.surface_add_vertex(anchor_position)
	line_mesh.surface_end()


# Расчет нагрузки на леску
func get_tension_ratio() -> float:
	if line_data == null:
		return 0.0
	var breaking_force := (line_data.breaking_strength_kg * 9.81)
	if breaking_force <= 0.0:
		return 0.0
	return current_tension / breaking_force
