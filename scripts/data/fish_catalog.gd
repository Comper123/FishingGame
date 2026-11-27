class_name FishCatalog
extends RefCounted

const FISH_TYPES := [
	{
		"id": "crucian_carp",
		"name": "Карась",
		"icon": preload("res://assets/fish/crucian_carp.png"),
		"min_weight": 0.2,
		"max_weight": 1.5
	},
	{
		"id": "perch",
		"name": "Окунь",
		"icon": preload("res://assets/fish/perch.png"),
		"min_weight": 0.15,
		"max_weight": 2.0
	},
	{
		"id": "northern_pike",
		"name": "Щука",
		"icon": preload("res://assets/fish/northern_pike.png"),
		"min_weight": 1.0,
		"max_weight": 7.0
	},
	{
		"id": "roach",
		"name": "Плотва",
		"icon": preload("res://assets/fish/roach.png"),
		"min_weight": 0.05,
		"max_weight": 1.5
	},
	{
		"id": "common_bream",
		"name": "Лещ",
		"icon": preload("res://assets/fish/common_bream.png"),
		"min_weight": 0.2,
		"max_weight": 6.0
	},
	{
		"id": "ruffe",
		"name": "Ёрш",
		"icon": preload("res://assets/fish/ruffe.png"),
		"min_weight": 0.02,
		"max_weight": 0.4
	},
	{
		"id": "white_bream",
		"name": "Густера",
		"icon": preload("res://assets/fish/white_bream.png"),
		"min_weight": 0.05,
		"max_weight": 1.2
	},
	{
		"id": "bleak",
		"name": "Уклейка",
		"icon": preload("res://assets/fish/bleak.png"),
		"min_weight": 0.02,
		"max_weight": 0.2
	},
	{
		"id": "ide",
		"name": "Язь",
		"icon": preload("res://assets/fish/ide.png"),
		"min_weight": 0.2,
		"max_weight": 4.0
	},
	{
		"id": "asp",
		"name": "Жерех",
		"icon": preload("res://assets/fish/asp.png"),
		"min_weight": 0.3,
		"max_weight": 12.0
	},
]


static func get_random_fish() -> Dictionary:
	return FISH_TYPES.pick_random()
