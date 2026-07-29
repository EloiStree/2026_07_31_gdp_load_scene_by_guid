
```
git submodule add https://github.com/EloiStree/2026_07_31_gdp_load_scene_by_guid.git addons/2026_07_31_gdp_load_scene_by_guid
```

# 2026_07_31_gdp_load_scene_by_guid

> Tool to generate a list of scene paths in your project and load them by GUID.

I want to design a game for learning to code without a menu, to avoid wasting time.

Instead, you can send a scene GUID over UDP or enter its number directly.

Godot allows you to load a scene if you know its path.

This tool generates a file in the editor containing all the scenes in the project. It then uses the `.guid` files in each folder to build a dictionary that maps GUIDs to scene paths.

In this setup, each folder should contain only one scene. This allows you to rename a scene without breaking existing references.


_Very, useful if you use NFC or bar-code scanner._
