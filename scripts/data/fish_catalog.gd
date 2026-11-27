class_name FishCatalog
extends RefCounted

const FISH_TYPES := [
	{
		"name": "Карась",
		"icon": preload("res://assets/fish/crucian_carp.png"),
		"min_weight": 0.2,
		"max_weight": 1.5
	},
	{
		"name": "Окунь",
		"icon": preload("res://assets/fish/perch.png"),
		"min_weight": 0.15,
		"max_weight": 2.0
	},
	{
		"name": "Щука",
		"icon": preload("res://assets/fish/northern_pike.png"),
		"min_weight": 1.0,
		"max_weight": 7.0
	}
]

static func get_random_fish() -> Dictionary:
	return FISH_TYPES.pick_random()
