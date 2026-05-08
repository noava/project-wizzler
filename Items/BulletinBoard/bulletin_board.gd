extends Node3D

@onready var prev_btn: StaticBody3D = $Buttons/PrevBtn
@onready var next_btn: StaticBody3D = $Buttons/NextBtn
@onready var page_count_label: Label3D = $Buttons/PageCount
@onready var bulletin_board_info: Node = $Plane/SubViewport/BulletinBoardInfo

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("item_interact"): # When taking photos
		_update_page_count_label()

func _update_page_count_label() -> void:
	var page_no: int = bulletin_board_info.get_current_page_number()
	var page_count: int = bulletin_board_info.get_page_count()

	if page_no <= 0:
		page_count_label.text = "0/0"
	else:
		page_count_label.text = str(page_no) + "/" + str(page_count)


func _on_next_btn_on_btn_clicked() -> void:
	bulletin_board_info.next_page()
	_update_page_count_label()


func _on_prev_btn_on_btn_clicked() -> void:
	bulletin_board_info.prev_page()
	_update_page_count_label()
