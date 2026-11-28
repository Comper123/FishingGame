class_name FishData
extends Resource


@export var id: StringName
@export var display_name: String
@export_multiline var description: String

@export var icon: Texture2D

@export_range(0.001, 1000.0,  0.001, "or_greater")
var min_weight_kg: float = 0.1

@export_range(0.001, 1000.0, 0.001, "or_greater")
var max_weight_kg: float = 1.0
