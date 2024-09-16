extends Control

@onready var h_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HSlider
@onready var s_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/SSlider
@onready var v_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/VSlider
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var file_dialog: FileDialog = $FileDialog

@onready var image: Image = Image.load_from_file(ImagePath.image_path)
var texture: ImageTexture

func _ready() -> void:
	texture = ImageTexture.create_from_image(image)
	
	texture_rect.texture = texture
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			var c = rgb_to_hsv(current_pixel.r, current_pixel.g, current_pixel.b)
			image.set_pixel(x, y, Color.from_hsv(c[0]/360.0, c[1], c[2]))
	
	texture_rect.texture = ImageTexture.create_from_image(image)


func rgb_to_hsv(r, g, b):
	var mx = max(r, g, b)
	var mn = min(r, g, b)
	var df = mx-mn
	var h = 0; var s = 0; var v = 0
	
	if mx == mn:
		h = 0
	elif mx == r:
		if g >= b:
			h = 60 * (g-b)/df
		else:
			h = 60 * (g-b)/df + 360
	elif mx == g:
		h = 60 * (b-r)/df + 120
	elif mx == b:
		h = 60 * (r-g)/df + 240
	
	if mx == 0:
		s = 0
	else:
		s = 1-mn/mx
	
	v = mx
	
	return [h, s, v]


func _on_slider_value_changed(value: float) -> void:
	var h = h_slider.value
	var s = s_slider.value
	var v = v_slider.value
	var old_image = texture.get_image()
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = old_image.get_pixel(x, y)
			var c = rgb_to_hsv(current_pixel.r, current_pixel.g, current_pixel.b)
			image.set_pixel(x, y, Color.from_hsv(fmod(c[0] + h, 360) / 360.0, c[1] + s, c[2] + v))
	
	texture_rect.texture = ImageTexture.create_from_image(image)


func _on_button_pressed() -> void:
	file_dialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	texture_rect.texture.get_image().save_jpg(path, 1)


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
