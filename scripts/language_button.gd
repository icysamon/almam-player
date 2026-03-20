extends VBoxContainer

@onready var option_button: OptionButton = $OptionButton
var locales = ["en", "ja"]


func _ready() -> void:
	var current_locale = TranslationServer.get_locale()
	for i in range(locales.size()):
		if current_locale.begins_with(locales[i]):
			option_button.selected = i
			break


func _on_option_button_item_selected(index: int) -> void:
	TranslationServer.set_locale(locales[index])
	pass # Replace with function body.
