tool
extends EditorPlugin

const ShaderCache = preload("res://addons/gd-shader-cache/src/ShaderCache.gd")


func _enter_tree():
	add_custom_type("ShaderCache", "Spatial", ShaderCache, null)
	add_autoload_singleton("ShaderCacheManager", "res://addons/gd-shader-cache/src/ShaderCacheManager.gd")
