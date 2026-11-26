class_name InventoryUI
extends PanelContainer


@export var inventory: FishingInventory

@onready var capacity_label: Label = ($ContentMargin/Content/CapacityLabel)
@onready var fish_list: VBoxContainer = ($ContentMargin/Content/FishScroll/FishList)


func _ready() -> void:
	hide()
	if inventory == null:
		push_error("Inventory не назначен в InventoryUI")
		return
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
		var fish_label := Label.new()
		fish_label.text = fish.get_display_text()
		fish_list.add_child(fish_label)


func clear_fish_list() -> void:
	for child in fish_list.get_children():
		child.queue_free()
