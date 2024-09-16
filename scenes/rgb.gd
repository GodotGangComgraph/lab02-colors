extends Control

@onready var image: Image = Image.load_from_file(ImagePath.image_path)

@onready var texture_rect: TextureRect = $VBoxContainer/HBoxContainer/TextureRect

@onready var chart_scn: PackedScene = load("res://addons/easy_charts/control_charts/chart.tscn")
var chart: Chart

var texture: ImageTexture


func _ready() -> void:
	texture = ImageTexture.create_from_image(image)
	
	texture_rect.texture = texture
	
	draw_hists()


func draw_hists():
	chart = chart_scn.instantiate()
	$VBoxContainer/HBoxContainer.add_child(chart)
	
	var val: Array = range(256)
	
	var freq_red: Array = [] ; freq_red.resize(256) ; freq_red.fill(0)
	var freq_green: Array = [] ; freq_green.resize(256) ; freq_green.fill(0)
	var freq_blue: Array = [] ; freq_blue.resize(256) ; freq_blue.fill(0)
	
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			freq_red[current_pixel.r8] += 1
			freq_green[current_pixel.g8] += 1
			freq_blue[current_pixel.b8] += 1

	chart.set_y_domain(0, 15000)
	chart.set_x_domain(0, 255)
	var f1_1 = Function.new(val.slice(0, 100), freq_red.slice(0, 100), "Red", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#ff0000") })
	var f1_2 = Function.new(val.slice(100, 200), freq_red.slice(100, 200), "Red", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#ff0000") })
	var f1_3 = Function.new(val.slice(200, 256), freq_red.slice(200, 256), "Red", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#ff0000") })
	
	var f2_1 = Function.new(val.slice(0, 100), freq_green.slice(0, 100), "Green", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#00ff00") })
	var f2_2 = Function.new(val.slice(100, 200), freq_green.slice(100, 200), "Green", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#00ff00") })
	var f2_3 = Function.new(val.slice(200, 256), freq_green.slice(200, 256), "Green", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#00ff00") })
	
	var f3_1 = Function.new(val.slice(0, 100), freq_blue.slice(0, 100), "Blue", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#0000ff") })
	var f3_2 = Function.new(val.slice(100, 200), freq_blue.slice(100, 200), "Blue", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#0000ff") })
	var f3_3 = Function.new(val.slice(200, 256), freq_blue.slice(200, 256), "Blue", { marker = Function.Marker.CIRCLE, type = Function.Type.LINE, color = Color("#0000ff") })
	
	chart.plot([f1_1, f1_2, f1_3, f2_1, f2_2, f2_3, f3_1, f3_2, f3_3])



func _on_enable_blue_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		texture_rect.texture = disable_blue()
	else:
		texture_rect.texture = enable_blue()

func _on_enable_green_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		texture_rect.texture = disable_green()
	else:
		texture_rect.texture = enable_green()

func _on_enable_red_toggled(toggled_on: bool) -> void:
	if !toggled_on:
		texture_rect.texture = disable_red()
	else:
		texture_rect.texture = enable_red()

func disable_blue():
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			current_pixel = Color(current_pixel.r, current_pixel.g, 0, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	return ImageTexture.create_from_image(image)

func enable_blue():
	var original_image = texture.get_image()
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			var original_pixel = original_image.get_pixel(x, y)
			current_pixel = Color(current_pixel.r, current_pixel.g, original_pixel.b, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	return ImageTexture.create_from_image(image)

func disable_green():
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			current_pixel = Color(current_pixel.r, 0, current_pixel.b, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	return ImageTexture.create_from_image(image)

func enable_green():
	var original_image = texture.get_image()
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			var original_pixel = original_image.get_pixel(x, y)
			current_pixel = Color(current_pixel.r, original_pixel.g, current_pixel.b, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	return ImageTexture.create_from_image(image)

func disable_red():
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			current_pixel = Color(0, current_pixel.g, current_pixel.b, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	return ImageTexture.create_from_image(image)

func enable_red():
	var original_image = texture.get_image()
	
	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			var original_pixel = original_image.get_pixel(x, y)
			current_pixel = Color(original_pixel.r, current_pixel.g, current_pixel.b, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	return ImageTexture.create_from_image(image)




func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
