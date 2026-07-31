
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



Format: `guid.txt`   
```
9PuzTgJ89XkgFGfBZRsBVHMaDzHF1iLswWfG2wjeJMMb
Short title to display in UI
A short description to display in the menu explaining what this scene demonstrates in one line.

Rest of the file is a small BBCode description for the RichText of the game engine.    
A description of what the scene should do.   
```
