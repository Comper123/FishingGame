class_name FishingLoadout
extends Node


signal equipment_changed

var line: LineData


# Снаряжение лески
func equip_line(new_line: LineData) -> bool:
	if new_line == null:
		return false
	line = new_line
	equipment_changed.emit()
	return true


func remove_line() -> void:
	line = null
	equipment_changed.emit()
	

func has_line() -> bool:
	return line != null
	
