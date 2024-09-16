extends Control

@onready var h_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/HSlider
@onready var s_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/SSlider
@onready var v_slider: HSlider = $MarginContainer/VBoxContainer/VBoxContainer/GridContainer/VSlider
@onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect

@onready var image: Image = Image.load_from_file("res://ФРУКТЫ.jpg")
var texture: ImageTexture

var h_old = 0
var s_old = 0
var v_old = 0

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
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			var c = rgb_to_hsv(current_pixel.r, current_pixel.g, current_pixel.b)
			image.set_pixel(x, y, Color.from_hsv((c[0]+h-h_old)/360.0, c[1]+s-s_old, c[2]+v-v_old))
	
	texture_rect.texture = ImageTexture.create_from_image(image)
	
	h_old = h
	s_old = s
	v_old = v
