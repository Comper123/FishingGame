class_name CaughtFish
extends RefCounted


var species_name: String
var weight: float
var icon: Texture2D


func _init(
	new_species_name: String,
	new_weight: float,
	new_icon: Texture2D
) -> void:
	species_name = new_species_name
	weight = new_weight
	icon = new_icon


func get_display_text() -> String:
	return "%s - %.2f кг" % [species_name, weight]
