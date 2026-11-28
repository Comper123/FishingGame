class_name FishCatalog
extends RefCounted

const FISH_TYPES: Array[FishData] = [
	preload("res://data/fish/crucian_carp.tres"),
	preload("res://data/fish/perch.tres"),
	preload("res://data/fish/northern_pike.tres"),
	preload("res://data/fish/roach.tres"),
	preload("res://data/fish/common_bream.tres"),
	preload("res://data/fish/ruffe.tres"),
	preload("res://data/fish/white_bream.tres"),
	preload("res://data/fish/bleak.tres"),
	preload("res://data/fish/ide.tres"),
	preload("res://data/fish/asp.tres"),
]


static func get_random_fish() -> FishData:
	return FISH_TYPES.pick_random()
