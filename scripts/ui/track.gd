extends Control

@onready var color_rect: ColorRect = %ColorRect
@onready var nine_patch_rect: NinePatchRect = $BoxContainer/BoxContainer2/NinePatchRect
@onready var note_effect_preview: TextureRect = $BoxContainer/BoxContainer/NoteEffectPreview
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var label: Label = $BoxContainer/BoxContainer/Label
@onready var color_picker_button: ColorPickerButton = $BoxContainer/BoxContainer/ColorPickerButton
@onready var spin_box: SpinBox = $BoxContainer/BoxContainer/SpinBox
@onready var left_margin_slider: Slider = $BoxContainer/BoxContainer2/LeftMarginSlider
@onready var right_margin_slider: Slider = $BoxContainer/BoxContainer2/RightMarginSlider
@onready var file_dialog: FileDialog = $BoxContainer/BoxContainer/FileDialog
@onready var file_dialog_2: FileDialog = $BoxContainer/BoxContainer/FileDialog2
@onready var check_box: Button = $BoxContainer/BoxContainer/CheckBox
@onready var color_check_box: Button = $BoxContainer/BoxContainer/ColorCheckBox
@onready var gradient_start: Sprite2D = $BoxContainer/BoxContainer/GradientStart

var number: int = 0
var parallax: float = 1.0
var text: String = ""
var note_texture: String = "res://assets/images/note_staccato.png"
var note_effect_texture: String = "res://assets/sprites/note_effect_texture.png"
var color: Color = Color(1.0, 1.0, 1.0, 1.0)
var default_texture: CompressedTexture2D = load("res://assets/images/note.png")
var default_staccato_texture: CompressedTexture2D = load("res://assets/images/note_staccato.png")
var default_effect_texture: CompressedTexture2D = load("res://assets/sprites/note_effect_texture.png")
var note_margins: Vector2 = Vector2(12,12)
var mouse_inside_note: bool = false
var mouse_inside_noteon: bool = false
var staccato: bool = false
var dont_color: bool = false
var main_interface: Control


func _ready():
	main_interface = get_tree().get_nodes_in_group("MainInterface")[0]
	set_note_texture()
	nine_patch_rect.custom_minimum_size = nine_patch_rect.texture.get_size()
	await get_tree().process_frame
	if number % 2 == 1:
		color_rect.color = Color("#eee3ff")
	else:
		color_rect.color = Color("#ffe6c2")
	await get_tree().create_timer(number * 0.04).timeout
	animation_player.play("start")


func _physics_process(_delta):
	color_picker_button.color = lerp(color_picker_button.color, color, 0.1)
	nine_patch_rect.self_modulate = lerp(nine_patch_rect.self_modulate, color, 0.1)
	if not GlobalVariables.dont_color[str(number)]:
		note_effect_preview.self_modulate = lerp(note_effect_preview.self_modulate, color, 0.1)


func _on_color_picker_button_color_changed(new_color):
	self.color = new_color
	nine_patch_rect.self_modulate = new_color
	if not GlobalVariables.dont_color[str(number)]:
		note_effect_preview.self_modulate = new_color
	GlobalVariables.colors[str(number)] = new_color 
	#GlobalVariables.save_settings()
	
	main_interface.LivePreview.notify_global_variable_change("colors")
	

func _on_color_picker_button_gui_input(event):
	await get_tree().process_frame

	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_RIGHT:
				if main_interface.gradient_start == null:
					main_interface.gradient_start = number
#					$Container/GradientStart.scale = Vector2(0.635, 0.953)
					var start_tween = get_tree().create_tween()
					start_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
					start_tween.tween_property(gradient_start, "scale", Vector2(0.635, 0.953), 0.1)
#					$Container/GradientStart.visible = true
				else:
					main_interface.create_gradient(number)


func _on_spin_box_value_changed(value):
	GlobalVariables.parallax[str(number)] = value
	#GlobalVariables.save_settings()
	

func _on_note_texture_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				file_dialog.show()

			MOUSE_BUTTON_RIGHT:
				GlobalVariables.note_texture[str(number)] = "res://assets/sprites/note_texture.png"
				set_note_texture()


func _on_file_dialog_file_selected(path):
	GlobalVariables.note_texture[str(number)] = path
	set_note_texture()
#	await get_tree().create_timer(0.15).timeout
	#GlobalVariables.save_settings()


func _on_file_dialog_2_file_selected(path):
	GlobalVariables.note_effect_texture[str(number)] = path
	note_effect_texture = path
	apply_note_effect_texture()
	set_effect_texture()
#	await get_tree().create_timer(0.15).timeout
	#GlobalVariables.save_settings()


func _on_left_margin_slider_value_changed(value):
	nine_patch_rect.patch_margin_left = value
	GlobalVariables.note_texture_margins[str(number)] = Vector2(value, GlobalVariables.note_texture_margins[str(number)].y)
	#GlobalVariables.save_settings()
	main_interface.LivePreview.notify_global_variable_change("note_texture_margins")


func _on_right_margin_slider_value_changed(value):
	nine_patch_rect.patch_margin_right = value
	GlobalVariables.note_texture_margins[str(number)] = Vector2(GlobalVariables.note_texture_margins[str(number)].x, value)
	#GlobalVariables.save_settings()
	main_interface.LivePreview.notify_global_variable_change("note_texture_margins")


func _on_check_box_toggled(button_pressed):
	if button_pressed:
		nine_patch_rect.set_h_size_flags(nine_patch_rect.SIZE_SHRINK_CENTER)
	else:
		nine_patch_rect.set_h_size_flags(nine_patch_rect.SIZE_EXPAND_FILL)
	GlobalVariables.staccato[str(number)] = button_pressed
	#GlobalVariables.save_settings()
	main_interface.LivePreview.notify_global_variable_change("staccato")


func _on_color_check_box_toggled(button_pressed):
	if button_pressed:
		note_effect_preview.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		note_effect_preview.self_modulate = GlobalVariables.colors[str(number)]
	GlobalVariables.dont_color[str(number)] = button_pressed
	#GlobalVariables.save_settings()
	main_interface.LivePreview.notify_global_variable_change("colors")


func _on_note_texture_button_mouse_entered():
	mouse_inside_note = true


func _on_note_texture_button_mouse_exited():
	mouse_inside_note = false


func _on_note_effect_button_mouse_exited():
	mouse_inside_noteon = false


func _on_note_effect_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				file_dialog_2.show()

			MOUSE_BUTTON_RIGHT:
				GlobalVariables.note_effect_texture[str(number)] = "res://assets/sprites/note_effect_texture.png"
				set_effect_texture()


func apply_color():
	label.text = text
#	color_picker_button.color = color
#	nine_patch_rect.self_modulate = color
#	if not GlobalVariables.dont_color[str(number)]:
#		note_effect_preview.self_modulate = color
	GlobalVariables.colors[str(number)] = color
	#GlobalVariables.save_settings()


func apply_parallax():
	spin_box.value = parallax
	GlobalVariables.parallax[str(number)] = parallax
	#GlobalVariables.save_settings()

	main_interface.LivePreview.notify_global_variable_change("parallax")


func apply_note_texture():
	GlobalVariables.note_texture[str(number)] = note_texture
	#GlobalVariables.save_settings()
	set_note_texture()
#	nine_patch_rect.custom_minimum_size = nine_patch_rect.texture.get_size()


func apply_note_margins():
	left_margin_slider.value = GlobalVariables.note_texture_margins[str(number)].x
	right_margin_slider.value = GlobalVariables.note_texture_margins[str(number)].y
#	GlobalVariables.note_texture_margins[str(number)] = note_margins
	#GlobalVariables.save_settings()
#	set_note_texture()


func apply_note_effect_texture():
#	note_effect_texture
	GlobalVariables.note_effect_texture[str(number)] = note_effect_texture
	#GlobalVariables.save_settings()
	set_effect_texture()


func apply_staccato():
	GlobalVariables.staccato[str(number)] = staccato
	check_box.button_pressed = GlobalVariables.staccato[str(number)]
	#GlobalVariables.save_settings()
	main_interface.LivePreview.notify_global_variable_change("staccato")


func apply_dont_color():
	GlobalVariables.dont_color[str(number)] = dont_color
	color_check_box.button_pressed = GlobalVariables.dont_color[str(number)]
	#GlobalVariables.save_settings()
	main_interface.LivePreview.notify_global_variable_change("dont_color")


func set_note_texture():
	var image: Image
	var note_texture_path = str(GlobalVariables.note_texture.get(str(number)))
	
	# When path is res://
	if note_texture_path.begins_with("res://"):
		nine_patch_rect.texture = load(note_texture_path)
		nine_patch_rect.custom_minimum_size = nine_patch_rect.texture.get_size()
		#nine_patch_rect.custom_minimum_size.x = 250
		nine_patch_rect.custom_minimum_size.y = 18
		return
	# When path is user://
	elif (note_texture_path != "<null>"):
		image = Image.load_from_file(note_texture_path)
		nine_patch_rect.texture = ImageTexture.create_from_image(image)
		nine_patch_rect.custom_minimum_size = nine_patch_rect.texture.get_size()
		#nine_patch_rect.custom_minimum_size.x = 250
		nine_patch_rect.custom_minimum_size.y = 18
		main_interface.LivePreview.notify_global_variable_change("note_texture")
		return
	# # When path is null
	else:
		push_warning("note texture path is null!")
		return


func set_effect_texture():
	await get_tree().create_timer(0.1).timeout
#	print(number)
	if GlobalVariables.note_effect_texture[str(number)] == "res://assets/sprites/note_effect_texture.png":
		note_effect_preview.texture = default_effect_texture
#		nine_patch_rect.custom_minimum_size.x = 250
#		nine_patch_rect.custom_minimum_size.y = 18
		main_interface.LivePreview.notify_global_variable_change("note_effect_texture")
		return
#	var image = Image.new()
#	var err = image.load(GlobalVariables.note_effect_texture[str(number)])
#	if err != OK:
#		# Failed
#		print("error loading image :(")
#	note_effect_preview.texture = ImageTexture.new()
	note_effect_preview.texture = ImageTexture.create_from_image(Image.load_from_file(GlobalVariables.note_effect_texture[str(number)]))
#	note_effect_preview.texture.create_from_image(image)
#	note_effect_preview.custom_minimum_size = note_effect_preview.texture.get_size()
	main_interface.LivePreview.notify_global_variable_change("note_effect_texture")
