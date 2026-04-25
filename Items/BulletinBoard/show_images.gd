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
	for i in Global.imagesTaken.slice(start_index, end_index):
		var img = BOARD_IMAGE.instantiate()
		img.get_node("TextureRect").texture = i.texture
		
		img.get_node("BugName").text = str(i.animals[0].animal_name) if i.animals.size() > 0 else "" # Only get the first animal

		gallery.add_child(img)

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
