class_name GuidLoadGenerateButtonsToLoadScene
extends Node

@export var _prefab_button_to_load:Button
@export var _parent_to_create_in:VBoxContainer

@export var _delay_generation=0.1

func _ready() -> void:
	await get_tree().create_timer(_delay_generation).timeout
	var info:=GuidLoadProjectGuidTxtAsStatic.get_list_of_guid_info()
	for info_bean in info:
		var new_button = _prefab_button_to_load.duplicate() as Button
		new_button.text = info_bean._documentation_title
		new_button.name = info_bean._guid
		new_button.connect("pressed", Callable(self, "_on_button_pressed").bind(info_bean._guid))
		_parent_to_create_in.add_child(new_button)
		new_button.show()

func _on_button_pressed(guid:String) -> void:
	_load_scene_from_guid(guid)


func _load_scene_from_guid(guid:String) -> void:
	var scene_path = GuidLoadProjectGuidTxtAsStatic.get_scene_path_of_guid(guid)
	if scene_path != "":
		var scene_resource = ResourceLoader.load(scene_path)
		if scene_resource:
			get_tree().change_scene_to_file(scene_path)
		else:
			push_error("Failed to load scene resource at path: " + scene_path)
	else:
		push_error("GUID not found in dictionary: " + guid)
