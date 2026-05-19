extends Control

@onready var objective_label: RichTextLabel = $MarginContainer/RichTextLabel

func _process(_delta: float) -> void:
	var animals_set: Dictionary = {}
	var species_set: Dictionary = {}

	for animal in Global.animals_found:
		var animals_name: String = str(animal.animal_name)
		var animal_type_name: String = str(animal.animal_type)
		animals_set[animals_name] = true
		species_set[animal_type_name] = true
		Global.species_set = species_set

	var animal_count: int = animals_set.size()
	var different_animals: int = species_set.size()
	objective_label.text = "[u]Objectives[/u]\n\nAnimals found: %d\nDifferent animals: %d" % [animal_count, different_animals]
