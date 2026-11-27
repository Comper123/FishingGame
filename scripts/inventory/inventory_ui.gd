class_name InventoryUI
extends PanelContainer


@export var inventory: FishingInventory
@export var fish_card_scene: PackedScene


@onready var capacity_label: Label = ($ScreenMargin/MainLayout/Sidebar/CapacityLabel)
@onready var fish_grid: GridContainer  = ($ScreenMargin/MainLayout/MainContent/FishScroll/FishGrid)
@onready var close_button: Button = ($ScreenMargin/MainLayout/MainContent/Header/CloseButton)

func _ready() -> void:	
	hide()
	if inventory == null:
		push_error("Inventory не назначен в InventoryUI")
		return
	close_button.pressed.connect(close_inventory)
	inventory.inventory_changed.connect(refresh_inventory)
	refresh_inventory()
	

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("toggle_inventory"):
		toggle_inventory()


# Управление видимостью инвентаря
func toggle_inventory() -> void:
	visible = not visible
	if visible:
		refresh_inventory()
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		

func refresh_inventory() -> void:
	clear_fish_list()
	
	capacity_label.text = "Рыба: %d / %d" % [inventory.get_count(), inventory.capacity]
	
	for fish in inventory.get_items():
		var card := fish_card_scene.instantiate() as FishCard
		fish_grid.add_child(card)
		card.setup(fish, fish.icon)


func clear_fish_list() -> void:
	for child in fish_grid.get_children():
		child.queue_free()


func close_inventory() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
