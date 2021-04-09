extends PanelContainer


export var firework_script_path = "res://addons/fireworks/fireworks_script/"
export var firework_player = "res://addons/fireworks/PlayFireworks.tscn"
export var firework_editor = "res://addons/fireworks/FireworksEditor.tscn"

onready var menu_button = $Panel/VBoxContainer/HBoxContainer/MenuButton
onready var run_button = $Panel/VBoxContainer/HBoxContainer/RunButton
onready var edit_button = $Panel/VBoxContainer/HBoxContainer/EditButton

var name_to_path = {}



func _ready():
	run_button.connect("pressed",self,"run")
	edit_button.connect("pressed",self,"edit")
	_load()
	menu_button.select(0)
	
func _load():
	var dir = Directory.new()
	if dir.open(firework_script_path) == OK:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".fw"):
				name_to_path["selected script: " + file_name] = dir.get_current_dir() + file_name
			file_name = dir.get_next()
	else:
		$Panel/VBoxContainer/Title.text += "\n There was an error finding the scripts"
	for k in menu_button.get_item_count():
		menu_button.remove_item(0)
		
	for p in name_to_path.keys():
		menu_button.get_popup().add_item(p)


	
func get_current_path():
	var i_name = menu_button.get_item_text(menu_button.selected)
	var path = name_to_path[i_name]
	return path

func run():
	var f = File.new()
	f.open(get_current_path(),File.READ)
	var run_content = f.get_as_text()
	var player = load(firework_player).instance()
	add_child(player)
	$Panel.visible = false
	player.play_text(run_content)
	yield(player,"FireWorkDone")
	yield(get_tree().create_timer(2.0),"timeout")
	$Panel.visible = true
	player.queue_free()

func edit():
	var f = File.new()
	f.open(get_current_path(),File.READ)
	$Panel.visible = false
	
	var editor = load(firework_editor).instance()
	add_child(editor)
	
	editor.text = f.get_as_text()
	editor.path = get_current_path()
	yield(editor,"Finished")
	editor.queue_free()
	_load()
	$Panel.visible = true

