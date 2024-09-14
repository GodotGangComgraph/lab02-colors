extends Control

@onready var file_dialog: FileDialog = $FileDialog
@onready var texture_rect: TextureRect = $TextureRect
@onready var source_image: Image = Image.new()

var texture_copy: ImageTexture


func _on_file_dialog_file_selected(path: String) -> void:
	source_image.load(path)
	#$Load/Label.text = "Loaded image from " + path 
	var texture: ImageTexture = ImageTexture.create_from_image(source_image)
	texture_rect.texture = texture
	texture_copy = texture


func _on_button_pressed() -> void:
	file_dialog.popup()


func _on_grayscale_item_selected(index: int) -> void:
	if index == 0:
		texture_rect.texture = texture_copy
	else:
		texture_rect.texture = to_gray_scale(index % 2 != 0)


func to_gray_scale(is_option_one):
	var image = texture_rect.texture.get_image()

	for y in image.get_size().y:
		for x in image.get_size().x:
			var current_pixel = image.get_pixel(x, y)
			var brightness
			
			if is_option_one:
				brightness = 0.299*current_pixel.r + 0.587*current_pixel.g + 0.114*current_pixel.b
			else:
				brightness = 0.2126*current_pixel.r + 0.7152*current_pixel.g + 0.0722*current_pixel.b
			
			current_pixel = Color(brightness, brightness, brightness, current_pixel.a)
			image.set_pixel(x, y, current_pixel)
	
	return ImageTexture.create_from_image(image)

func _on_extract_rgb_pressed() -> void:
	pass


func _on_convert_to_hsv_pressed() -> void:
	pass
