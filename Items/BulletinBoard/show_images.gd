extends Control
const BOARD_IMAGE = preload("uid://cq1hhps1y3mn6")
const IMAGES_PER_PAGE: int = 18

@onready var label: Label = $Panel/MarginContainer/Label
@onready var gallery: GridContainer = %Gallery

var current_page: int = 0

func _ready() -> void:
	current_page = 0
	show_images()
	label.visible = true
	gallery.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("item_interact") and Global.imagesTaken.size() > 0:
		show_images()

func show_images():
	label.visible = false
	gallery.visible = true
	remove_children()

	var start_index: int = current_page * IMAGES_PER_PAGE
	var end_index: int = min(start_index + IMAGES_PER_PAGE, Global.imagesTaken.size())
	for index in range(start_index, end_index):
		var img_data = Global.imagesTaken[index]
		var img: Control = BOARD_IMAGE.instantiate()
		img.get_node("TextureRect").texture = img_data.texture
		
		img.get_node("AnimalName").text = str(img_data.animals[0].animal_name) if img_data.animals.size() > 0 else "" # Only get the first animal

		var card: Control = Control.new() # For allowing rotation of each image
		card.custom_minimum_size = img.custom_minimum_size
		img.rotation_degrees = randf_range(-2.0, 2.0)
		card.add_child(img)
		gallery.add_child(card)

func remove_children():
	for c in gallery.get_children():
		gallery.remove_child(c)
		c.queue_free()


func next_page():
	if Global.imagesTaken.is_empty():
		return
	
	var page_count := get_page_count()
	current_page = (current_page + 1) % page_count
	show_images()

func prev_page():
	if Global.imagesTaken.is_empty():
		return
	
	var page_count := get_page_count()
	current_page = posmod(current_page - 1, page_count)
	show_images()


func get_page_count() -> int:
	return maxi(1, ceili(float(Global.imagesTaken.size()) / float(IMAGES_PER_PAGE)))


func get_current_page_number() -> int:
	if Global.imagesTaken.size() == 0:
		return 0
	return current_page + 1
