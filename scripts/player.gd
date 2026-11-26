extends CharacterBody3D

@export var speed: float = 5.0
@export var acceleration: float = 16.0
@export var jump_velocity: float = 5.0
@export var mouse_sensetivity: float = 0.002
@export var bobber_scene: PackedScene
@export var cast_force: float = 10.0
@export var cast_upward_force: float = 2.5

@onready var camera_pivot: Node3D = $CameraPivot
@onready var cast_origin: Marker3D = $CameraPivot/CastOrigin
@onready var catch_label: Label = $HUD/CatchLabel
@onready var message_timer: Timer = $HUD/MessageTimer

var current_bobber: Bobber = null     # Текущий поплавок
var inventory: Dictionary = {}

var gravity: float = float(
	ProjectSettings.get_setting("physics/3d/default_gravity")
)


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	catch_label.hide()
	message_timer.timeout.connect(_on_message_timer_timeout)


func _unhandled_input(event: InputEvent) -> void:
	if (event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		rotate_y(-event.relative.x * mouse_sensetivity)
		camera_pivot.rotate_x(-event.relative.y * mouse_sensetivity)
		
		camera_pivot.rotation.x = clampf(camera_pivot.rotation.x, deg_to_rad(-60.0), deg_to_rad(45.0))
		
	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed):
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if (event.is_action_pressed("cast") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED):
		if current_bobber == null:
			cast_bobber()
		elif current_bobber.try_hook():
			catch_fish()
		else:
			retrieve_bobber()


func _physics_process(delta: float) -> void:
	apply_gravity(delta)
	handle_jump()
	handle_movement(delta)
	move_and_slide()


func apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y -= gravity * delta


func handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity


func handle_movement(delta: float) -> void:
	var input_direction := Input.get_vector(
		"move_left",
		"move_right",
		"move_forward",
        "move_backward"
	)

	var direction := (transform.basis * Vector3(input_direction.x, 0.0, input_direction.y)).normalized()
	var target_velocity := direction * speed
	velocity.x = move_toward(velocity.x, target_velocity.x, acceleration * delta)
	velocity.z = move_toward(velocity.z, target_velocity.z, acceleration * delta)


# Бросок поплавка
func cast_bobber() -> void:
	if bobber_scene == null:
		push_warning("Bobber Scene не назначена")
		return
	
	current_bobber = bobber_scene.instantiate() as Bobber
	
	get_tree().current_scene.add_child(current_bobber)
	
	current_bobber.global_position = cast_origin.global_position
	current_bobber.global_rotation = cast_origin.global_rotation
	
	var forward := -cast_origin.global_basis.z
	
	current_bobber.apply_central_impulse(forward * cast_force + Vector3.UP * cast_upward_force)


# Сматывание поплавка
func retrieve_bobber() -> void:
	if not is_instance_valid(current_bobber):
		current_bobber = null
		return
	
	current_bobber.queue_free()
	current_bobber = null


# Поимка рыбы
func catch_fish() -> void:
	var fish: Dictionary = FishCatalog.get_random_fish()
	
	var fish_name := String(fish["name"])
	var fish_weight := randf_range(float(fish["min_weight"]), float(fish["max_weight"]))
	inventory[fish_name] = int(inventory.get(fish_name, 0)) + 1
	show_catch_message(fish_name, fish_weight)
	print("Инвентарь", inventory)
	retrieve_bobber()


func show_catch_message(fish_name: String, fish_weight: float) -> void:
	catch_label.text = "Поймана рыба: %s - %.2f кг" % [fish_name, fish_weight]
	catch_label.show()
	message_timer.start(3.0)

func _on_message_timer_timeout() -> void:
	catch_label.hide()
	
