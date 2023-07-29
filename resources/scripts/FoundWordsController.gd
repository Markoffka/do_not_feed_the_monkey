extends Node

@onready var rich_for_search :RichTextLabel = $"../TextForFind/MarginContainer/RichTextLabel"
@onready var founded_words_container = $"../FoundedWords/MarginContainer/HFlowContainer"
@onready var founded_word_e := preload("res://entities/founded_word.tscn")

@export var words_dictionary := {
	'$1': ['пример', false],
	'$2': ['Do Not Feed The Monkey', false],
	"@3" : ["datawo", false],
	"тексту": ["тексту", false],
}

var init_text

func _ready():
	init_text = rich_for_search.text
	format_text_to_meta()
	rich_for_search.meta_clicked.connect(on_meta)
	pass

# redraw text with meta
func format_text_to_meta():
	rich_for_search.text = init_text
	for i in words_dictionary:
		var replaceTo := format_word_to_meta_active(i, words_dictionary.get(i)[0], !words_dictionary.get(i)[1]);
		rich_for_search.text = rich_for_search.text.replacen(i, replaceTo)

# escape bbcode text
func escape_bbcode(bbcode_text):
	return bbcode_text.replace("[", "[lb]")

# format bbcode
func format_word_to_meta_active(searchFor, wordTo, active) -> String:
	return withColor(escape_bbcode(searchFor), withUrl(escape_bbcode(wordTo),searchFor, active), active)

# hoc func for coloring text
func withColor(key, word, is_active):
	return "[search active=%s]%s[/search]" % [is_active, word]

# hoc func for meta text
func withUrl(word, search, is_active):
	return word if not is_active else "[url=%s]%s[/url]" % [search, word]

# when clicking on the created label
func _on_founded_btn_clicked(arg):
	print("%s = %s" % [arg, words_dictionary[arg]])

# when clicking on the meta tag in the formatted text
func on_meta(founded_meta: String):
	var founded = words_dictionary.get(founded_meta);
	if founded == null: return
	var new_founded_button :Button = founded_word_e.instantiate()
	var text: String = founded[0]
	words_dictionary[founded_meta][1] = true
	new_founded_button.text = text
	new_founded_button.pressed.connect(_on_founded_btn_clicked.bind(founded_meta))
	founded_words_container.add_child(new_founded_button)
	format_text_to_meta()

# on clear founded tags
func _on_clear():
	for child in founded_words_container.get_children():
		if child is Button:
			child.pressed.disconnect(_on_founded_btn_clicked)
		child.queue_free()
		
	for search in words_dictionary:
		words_dictionary[search][1] = false
	format_text_to_meta()
