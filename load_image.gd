extends Control

@onready var file_dialog: FileDialog = $FileDialog
@onready var texture_rect: TextureRect = $Image/TextureRect
@onready var popup: Window = $Image

@onready var image: Image = Image.new()

func _on_file_dialog_file_selected(path: String) -> void:
	image.load(path)
	$Load/Label.text = "Loaded image from " + path 
	open_popup()
	
func open_popup():
	var texture: ImageTexture = ImageTexture.create_from_image(image)
	texture_rect.texture = texture
	popup.show()
	

func _on_button_pressed() -> void:
	file_dialog.popup()


func _on_image_close_requested() -> void:
	popup.hide()


func _on_grayscale_pressed() -> void:
	pass


func _on_extract_rgb_pressed() -> void:
	pass


func _on_convert_to_hsv_pressed() -> void:
	pass
