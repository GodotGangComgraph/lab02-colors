extends Control

@onready var h_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HSlider
@onready var s_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/SSlider
@onready var v_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/VSlider
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/HBoxContainer/TextureRect
@onready var file_dialog: FileDialog = $FileDialog

@onready var image: Image = Image.load_from_file(ImagePath.image_path)
var texture: ImageTexture

var image_map = []

func _ready() -> void:
	texture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture
	
	var old_image = texture.get_image()
	
	for x in range(image.get_size().x):
		image_map.append([])
		image_map[x]=[]
		for y in range(image.get_size().y):
			image_map[x].append([])
			image_map[x][y]=0

	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = old_image.get_pixel(x, y)
			var hsv = rgb_to_hsv(current_pixel.r, current_pixel.g, current_pixel.b)
			
			image_map[x][y] = hsv


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


func hsv_to_rgb(p_h, p_s, p_v):
	var i: int
	var f; var p; var q; var t
	
	var r; var g; var b
	
	if (p_s == 0.0):
		return [p_v, p_v, p_v]
	
	p_h /= 60.0
	p_h = fmod(p_h, 6.0)
	i = floor(p_h)
	
	f = p_h - i
	p = p_v * (1.0 - p_s)
	q = p_v * (1.0 - p_s * f)
	t = p_v * (1.0 - p_s * (1.0 - f))

	match(i):
		0:
			r = p_v
			g = t
			b = p
		1:
			r = q
			g = p_v
			b = p
		2:
			r = p
			g = p_v
			b = t
		3:
			r = p
			g = q
			b = p_v
		4:
			r = t
			g = p
			b = p_v
		_:
			r = p_v
			g = p
			b = q
	
	return [r, g, b]


func _on_slider_drag_ended(value_changed: bool) -> void:
	if !value_changed:
		return
	
	var h = h_slider.value
	var s = s_slider.value
	var v = v_slider.value
	var old_image = texture.get_image()
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var hsv = image_map[x][y]
			var rgb = hsv_to_rgb(fmod(hsv[0] + h, 360), hsv[1] + s, hsv[2] + v)
			image.set_pixel(x, y, Color(rgb[0], rgb[1], rgb[2]))
	
	texture_rect.texture = ImageTexture.create_from_image(image)


func _on_button_pressed() -> void:
	file_dialog.popup()


func _on_file_dialog_file_selected(path: String) -> void:
	texture_rect.texture.get_image().save_jpg(path, 1)


func _on_exit_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
