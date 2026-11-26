class_name FishingInventory
extends Node


signal inventory_changed
signal inventory_full

@export_range(1, 100, 1) var capacity: int = 20
var items: Array[CaughtFish] = []


func add_fish(fish: CaughtFish) -> bool:
	if is_full():
		inventory_full.emit()
		return false
	items.append(fish)
	inventory_changed.emit()
	return true
	

func is_full() -> bool:
	return items.size() >= capacity


func get_count() -> int:
	return items.size()
	

func get_items() -> Array[CaughtFish]:
	return items.duplicate()
