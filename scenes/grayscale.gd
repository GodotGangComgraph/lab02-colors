extends Control

var image: Image = Image.load_from_file(ImagePath.image_path)

@onready var texture_rect_1: TextureRect = $VBoxContainer/GridContainer/TextureRect
@onready var texture_rect_2: TextureRect = $VBoxContainer/GridContainer/TextureRect2
@onready var texture_rect_3: TextureRect = $VBoxContainer/GridContainer/TextureRect3
@onready var texture_rect_4: TextureRect = $VBoxContainer/GridContainer/TextureRect4

@onready var chart_scn: PackedScene = load("res://addons/easy_charts/control_charts/chart.tscn")
var chart: Chart

var texture: ImageTexture

func _ready() -> void:
	texture = ImageTexture.create_from_image(image)
	
	texture_rect_1.texture = texture
	texture_rect_2.texture = to_gray_scale(1)
	texture_rect_3.texture = to_gray_scale(2)
	texture_rect_4.texture = to_gray_scale(3)
	
	draw_hist(0)
	draw_hist(1)



func to_gray_scale(index):
	var image = texture.get_image()
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			
			var brightness
			
			if index == 1:
				brightness = 0.299*current_pixel.r + 0.587*current_pixel.g + 0.114*current_pixel.b
			elif index == 2:
				brightness = 0.2126*current_pixel.r + 0.7152*current_pixel.g + 0.0722*current_pixel.b
			elif index == 3:
				var brightness1 = 0.299*current_pixel.r + 0.587*current_pixel.g + 0.114*current_pixel.b
				var brightness2 = 0.2126*current_pixel.r + 0.7152*current_pixel.g + 0.0722*current_pixel.b
				brightness = brightness1 - brightness2
			else:
				var brightness1 = 0.299*current_pixel.r + 0.587*current_pixel.g + 0.114*current_pixel.b
				var brightness2 = 0.2126*current_pixel.r + 0.7152*current_pixel.g + 0.0722*current_pixel.b
				brightness = brightness2 - brightness1
			
			current_pixel = Color(brightness, brightness, brightness, current_pixel.a)
			
			image.set_pixel(x, y, current_pixel)
			
	return ImageTexture.create_from_image(image)
	

func draw_hist(index):
	var image
	
	if index == 0:
		image = texture_rect_2.texture.get_image()
	else:
		image = texture_rect_3.texture.get_image()
	
	chart = chart_scn.instantiate()
	$VBoxContainer/GridContainer.add_child(chart)
	
	var val: Array = range(256)
	
	var freq_red: Array = [] ; freq_red.resize(256) ; freq_red.fill(0)
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			freq_red[current_pixel.r8] += 1
	
	chart.set_y_domain(0, 20000)
	chart.set_x_domain(0, 255)
	var f1_1 = Function.new(val.slice(0, 100), freq_red.slice(0, 100), "Brightness", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#000000") })
	var f1_2 = Function.new(val.slice(100, 200), freq_red.slice(100, 200), "Brightness", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#000000") })
	var f1_3 = Function.new(val.slice(200, 256), freq_red.slice(200, 256), "Brightness", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#000000") })

	chart.plot([f1_1, f1_2, f1_3])


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
