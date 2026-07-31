class_name GuidLoadProjectGuidTxtAsStatic
extends Node


static var guid_to_scene_path_dico: Dictionary[String, GuidLoadBasicInfoBean] = {}

static func get_list_of_guid()->Array[String]:
	if guid_to_scene_path_dico==null:
		_load_guid_to_scene_path_dico()
	return guid_to_scene_path_dico.keys()

static func get_list_of_guid_info()->Array[GuidLoadBasicInfoBean]:
	if guid_to_scene_path_dico==null:
		_load_guid_to_scene_path_dico()
	return guid_to_scene_path_dico.values()

static func get_info_of_guid(guid:String)->GuidLoadBasicInfoBean:
	guid = guid.strip_edges()
	if guid_to_scene_path_dico==null:
		_load_guid_to_scene_path_dico()
	return guid_to_scene_path_dico.get(guid, null)

static func get_scene_path_of_guid(guid:String)->String:
	var info_bean = get_info_of_guid(guid)
	if info_bean:
		return info_bean._scene_path
	return ""

static func get_title_of_guid(guid:String)->String:
	var info_bean = get_info_of_guid(guid)
	if info_bean:
		return info_bean._documentation_title
	return ""

static func get_one_liner_of_guid(guid:String)->String:
	var info_bean = get_info_of_guid(guid)
	if info_bean:
		return info_bean._documentation_one_liner
	return ""
	
static func get_rich_bbcode_of_guid(guid:String)->String:
	guid = guid.strip_edges()
	if guid_to_scene_path_dico==null:
		_load_guid_to_scene_path_dico()
	var info_bean = guid_to_scene_path_dico.get(guid, null)
	if info_bean:
		return info_bean.documentation_rich_bbcode
	return ""



@export var _load_at_ready: bool = true
@export var _print_result_at_end: bool = true
@export_group("For Debugging")
@export var _debug_dictionnary_guid_title:Dictionary[String, String] = {}


func _ready() -> void:
	if _load_at_ready:
		_load_guid_to_scene_path_dico()
	if _print_result_at_end:
		print("STATIC DICO LOADING COUNT: " + str(guid_to_scene_path_dico.size()))
		for guid in guid_to_scene_path_dico.keys():
			var info_bean = guid_to_scene_path_dico[guid]
			print("STATIC DICO GUID: " + guid + ", Scene Path: " + info_bean._scene_path + ", Title: " + info_bean._documentation_title + ", One-liner: " + info_bean._documentation_one_liner)
	var list_of_guid = get_list_of_guid()
	for guid in list_of_guid:
		var info_bean = get_info_of_guid(guid)
		if info_bean:
			_debug_dictionnary_guid_title[guid] = info_bean._documentation_title
	

static func _load_guid_to_scene_path_dico() -> void:
	var dico: Dictionary[String, GuidLoadBasicInfoBean] = {}
	_recursive_search_guid_file_to_single_scene(dico, "res://")
	guid_to_scene_path_dico = dico
	
## Look for a file name guid.txt and read the information in it, if found.
static func _recursive_search_guid_file_to_single_scene(dico: Dictionary[String, GuidLoadBasicInfoBean], dir_path: String) -> void:
	var dir = DirAccess.open(dir_path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir() and file_name != "." and file_name != "..":
				_recursive_search_guid_file_to_single_scene(dico, dir_path + "/" + file_name)
			elif file_name == "guid.txt":
				var guid_file_content = FileAccess.get_file_as_string(dir_path + "/" + file_name).strip_edges()
				var first_list_ist = guid_file_content.split("\n")
				if first_list_ist.size() > 0:
					guid_file_content = first_list_ist[0].strip_edges()
				var scene_path = _find_single_scene_in_folder(dir_path)
				if scene_path:
					var info_bean = GuidLoadBasicInfoBean.new()
					info_bean._guid = guid_file_content
					info_bean._scene_path = scene_path
					dico[guid_file_content] = info_bean
					var second_line_title = ""
					var third_line_one_liner = ""
					var rest_of_lines = ""
					if first_list_ist.size() > 1:
						second_line_title = first_list_ist[1].strip_edges()
					if first_list_ist.size() > 2:
						third_line_one_liner = first_list_ist[2].strip_edges()
					if first_list_ist.size() > 3:
						rest_of_lines = "\n".join(first_list_ist.slice(3, first_list_ist.size())).strip_edges()
					info_bean._documentation_title = second_line_title
					info_bean._documentation_one_liner = third_line_one_liner
					info_bean._documentation_rich_bbcode = rest_of_lines
			file_name = dir.get_next()


## Look for the signel scene in the folder.
static func _find_single_scene_in_folder(folder_path: String) -> String:
	var dir = DirAccess.open(folder_path)
	var scene_files = []
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if not dir.current_is_dir() and file_name.ends_with(".tscn"):
				scene_files.append(file_name)
			file_name = dir.get_next()
	if scene_files.size() > 0:
		return folder_path + "/" + scene_files[0]
	return ""

class GuidLoadBasicInfoBean:
	var _guid: String
	var _scene_path: String
	var _documentation_title: String
	var _documentation_one_liner: String
	var _documentation_rich_bbcode: String
