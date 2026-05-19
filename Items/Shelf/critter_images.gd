extends Node3D

@export var image_index: int = 0

var animal_names: Array[String] = ["Gecko", "Herring", "Muskrat", "Rat", "Snake", "Sparrow"]

var color_paths: Array[String] = [
	"res://Items/Shelf/CritterImages/gecko-color.png",
	"res://Items/Shelf/CritterImages/herring-color.png",
	"res://Items/Shelf/CritterImages/muskrat-color.png",
	"res://Items/Shelf/CritterImages/rat-color.png",
	"res://Items/Shelf/CritterImages/snake-color.png",
	"res://Items/Shelf/CritterImages/sparrow-color.png",
]

var black_paths: Array[String] = [
	"res://Items/Shelf/CritterImages/gecko-black.png",
	"res://Items/Shelf/CritterImages/herring-black.png",
	"res://Items/Shelf/CritterImages/muskrat-black.png",
	"res://Items/Shelf/CritterImages/rat-black.png",
	"res://Items/Shelf/CritterImages/snake-black.png",
	"res://Items/Shelf/CritterImages/sparrow-black.png",
]


func _physics_process(_delta: float) -> void:
	show_color()


func show_color() -> void:
	for idx in animal_names.size():
		var board := get_board(idx)
		if board == null:
			continue
		
		var tex_rect := board.get_node("TextureRect") as TextureRect
		var name_label := board.get_node("AnimalName") as Label
		var is_found : bool = Global.species_set.get(animal_names[idx], false)
		var texture_path := color_paths[idx] if is_found else black_paths[idx]
		
		if ResourceLoader.exists(texture_path):
			var animal_tex := load(texture_path) as Texture2D
			tex_rect.texture = animal_tex
			name_label.text = animal_names[idx] if is_found else "???"

func get_board(idx: int) -> Control:
	var board_number := idx + 1
	return get_node_or_null("CritterImage%d/SubViewport/BoardImage" % board_number) as Control
