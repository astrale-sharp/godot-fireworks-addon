extends Panel


var fireworks = preload("res://addons/fireworks/PlayFireworks.tscn")

var text setget set_text
var path 

signal Finished

onready var text_edit = $Panel/HBoxContainer/TextEdit


onready var help_button = $Panel/HBoxContainer/TextEdit/Help
onready var save_button = $Panel/HBoxContainer/VBoxContainer/HBoxContainer/SaveButton
onready var return_button = $Panel/HBoxContainer/VBoxContainer/HBoxContainer/ReturnSelectorButton
onready var save_as_button = $Panel/HBoxContainer/VBoxContainer/HBoxContainer/SaveAs
onready var open_folder_button = $Panel/HBoxContainer/VBoxContainer/HBoxContainer/OpenFolder

onready var popup_label = $Popup
onready var file_dialog = $Panel/FileDialog

func set_text(v):
	text = v
	text_edit.text = v


func _ready():

	setup_editor()	
	
	help_button.connect("pressed",self,"display_help")
	save_button.connect("pressed",self,"save")
	save_as_button.connect("pressed",self,"save_as")
	return_button.connect("pressed",self,"return_to_menu")
	open_folder_button.connect("pressed",self,"open_folder")
	
	file_dialog.connect("file_selected",self,"_save_as")

func setup_editor():
	text_edit.add_color_region("#","",Color("dcc52b"),true)
	for k in [
		"wait",
		"fountain",
		"rocket",
		"flare",
		"wheel"
		]:
		text_edit.add_keyword_color(k,Color.red)
	for k in [
		"angle",
		"arandom",
		"height",
		"hrandom", 
		"effect",
		"color",
		"lifetime",
		"size",
		"count"

	]:
		text_edit.add_keyword_color(k,Color.orange)
	text_edit.grab_focus()


func display_help():
	print("h")
	var t = popup_label.get_node("RichTextLabel")
	t.text =fireworks.instance().get_help()
	popup_label.popup()
	
	
func save():
	var f = File.new()
	f.open(path,File.WRITE)
	f.store_string(text_edit.text)

func save_as():
	file_dialog.current_path = path
	file_dialog.current_file
	file_dialog.popup()

func _save_as(_path):
	path = _path
	save()

func return_to_menu():
	emit_signal("Finished")

#not implemented
func open_folder():
	assert(false)
	OS.shell_open(path)
