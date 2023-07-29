@tool
extends RichTextEffect
class_name RichTextSearch

# Syntax: [search active=false]value[/search]

# Define the tag name.
var bbcode = "search"

func _process_custom_fx(char_fx):
	var is_active_key = char_fx.env.get("active", 'true')
	char_fx.color = Color.YELLOW if is_active_key else Color.DIM_GRAY
	char_fx.set_meta("key", is_active_key)
	return true
