class_name GuidLoadLevelFromGuidFile
extends Node

@export var dictionary_res_file_path:String = "res://guid_to_scene_path.txt"
@export var splitter_in_file:String = "|"


func load_scene_from_guid(guid:String):
	var dico:Dictionary = _read_dictonnary_file()
	if dico.has(guid):
		var scene_path = dico[guid]
		var scene_resource = ResourceLoader.load(scene_path)
		if scene_resource:
			get_tree().change_scene_to_file(scene_path)
		else:
			push_error("Failed to load scene resource at path: " + scene_path)
	else:
		push_error("GUID not found in dictionary: " + guid)

func _read_dictonnary_file() -> Dictionary:
	var dico:Dictionary = {}
	var file = FileAccess.open(dictionary_res_file_path, FileAccess.READ)
	if file != null:
		var content = file.get_as_text()
		file.close()
		var lines = content.split("\n")
		for line in lines:
			if line.strip_edges() != "":
				var parts = line.split(splitter_in_file)
				if parts.size() == 2:
					var guid = parts[0].strip_edges()
					var scene_path = parts[1].strip_edges()
					dico[guid] = scene_path
	else:
		push_error("Failed to open dictionary file at path: " + dictionary_res_file_path)
	return dico
