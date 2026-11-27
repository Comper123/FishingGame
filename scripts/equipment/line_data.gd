class_name LineData
extends Resource


@export var id: StringName
@export var display_name: String
@export_multiline var description: String

@export var length_m: float = 50.0
@export var breaking_strength_kg: float = 4.0
@export_range(0.0, 1.0, 0.01) var elasticity: float = 0.15

@export var piece: int = 0 
