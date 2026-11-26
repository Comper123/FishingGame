class_name CaughtFish
extends RefCounted


var species_name: String
var weight: float


func _init(new_species_name: String, new_weight: float) -> void:
	species_name = new_species_name
	weight = new_weight


func get_display_text() -> String:
	return "%s - %.2f кг" % [species_name, weight]
