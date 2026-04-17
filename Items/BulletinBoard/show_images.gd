extends GridContainer
const BOARD_IMAGE = preload("uid://cq1hhps1y3mn6")


func _ready() -> void:
	show_images()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("item_interact"):
		show_images()


func show_images():
	remove_children()
	for i in Global.imagesTaken:
		var img = BOARD_IMAGE.instantiate()
		img.get_node("TextureRect").texture = i.texture
		
		img.get_node("BugName").text = str(i.insects[0].insect_name) if i.insects.size() > 0 else "" # Only get the first insect

		add_child(img)

func remove_children():
	for c in get_children():
		remove_child(c)
		c.queue_free()
