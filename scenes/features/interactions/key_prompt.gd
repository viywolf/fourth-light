extends Panel

var icons: Array[Resource] = [
	preload("res://assets/ui/icons/mouse_scroll_prompt_1.png"),
	preload("res://assets/ui/icons/mouse_scroll_prompt_2.png")
]

var cur_icon: int = 0

func _on_timer_timeout() -> void:
	cur_icon += 1
	cur_icon %= 2
	$TextureRect.texture = icons[cur_icon]
