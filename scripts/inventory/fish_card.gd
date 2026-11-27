class_name FishCard
extends PanelContainer


@onready var fish_image: TextureRect = ($CardMargin/CardContent/FishImage)
@onready var fish_name_label: Label = ($CardMargin/CardContent/FishNameLabel)
@onready var fish_weight_label: Label = ($CardMargin/CardContent/FishWeightLabel)

func setup(fish: CaughtFish, texture: Texture2D = null) -> void:
	fish_name_label.text = fish.species_name
	fish_weight_label.text = "%.2f кг" % fish.weight
	fish_image.texture = texture
