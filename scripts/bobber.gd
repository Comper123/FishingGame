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

@onready var bite_timer: Timer = $BiteTimer


var is_in_water: bool = false
var water_surface_y: float = 0.0

var default_linear_damp: float
var defaul_angular_damp: float 

var fishing_state: FishingState = FishingState.FLYING


func _ready() -> void:
	default_linear_damp = linear_damp
	defaul_angular_damp = angular_damp
	bite_timer.timeout.connect(_on_bite_timer_timeout)


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
