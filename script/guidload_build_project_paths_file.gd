@tool
## This class guid a file in the Godot project at the root that references to where is the guid.txt file and the scene near it.
class_name GuidLoadBuildProjectPathsFile
extends Node


signal on_guid_file_path_generated(guid_file_path: String)
signal on_guid_file_text_generated(dico_text_generated: String)


@export var local_project_root_file_to_generate: String = "res://guid_to_scene_path.txt"
@export var guid_file_to_look_for: String = "guid.txt"
@export var dico_splitter_in_file:String ="|"
## Click on this boolean to generate the guid_to_scene_path.txt file in the root of the project. This file will contain all the scene paths in the project, one per line.	
@export var generate_guid_file: bool = false:
	set(value):
		if value and Engine.is_editor_hint():
			_generate_guid_to_scene_path_file()
		generate_guid_file = false

@export var generate_at_ready: bool = true


func _ready() -> void:
	if generate_at_ready:
		_generate_guid_to_scene_path_file()

func _generate_guid_to_scene_path_file() -> void:
	var dico: Dictionary = {}
	_recursive_search_guid_file_to_single_scene(dico, "res://")

	var text :String = ""
	for guid in dico.keys():
		var scene_path = dico[guid]
		text += guid + dico_splitter_in_file + scene_path + "\n"

	var file = FileAccess.open(local_project_root_file_to_generate, FileAccess.WRITE)
	if file:
		file.store_string(text)
		file.close()
		
	on_guid_file_text_generated.emit(text)
	on_guid_file_path_generated.emit(local_project_root_file_to_generate)



func _recursive_search_guid_file_to_single_scene(dico: Dictionary, dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				_recursive_search_guid_file_to_single_scene(dico, dir_path + "/" + file_name)
			elif file_name == guid_file_to_look_for:
				var guid_file_content = FileAccess.get_file_as_string(dir_path + "/" + file_name).strip_edges()
				var first_list_ist = guid_file_content.split("\n")
				if first_list_ist.size() > 0:
					guid_file_content = first_list_ist[0].strip_edges()
				var scene_path = _find_single_scene_in_folder(dir_path)
				if scene_path:
					dico[guid_file_content] = scene_path
					print("Found guid: " + guid_file_content + " at scene path: " + scene_path)
			file_name = dir.get_next()


func _find_single_scene_in_folder(folder_path: String) -> String:
	var dir = DirAccess.open(folder_path)
	var scene_files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				scene_files.append(file_name)
			file_name = dir.get_next()
	
	if scene_files.size() == 1:
		return folder_path + "/" + scene_files[0]
	return ""
