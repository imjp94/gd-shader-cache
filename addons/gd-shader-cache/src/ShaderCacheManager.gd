extends Spatial

signal compiled(cache_path)

var camera = Camera.new()

var _compiled_cache_paths = []


func _ready():
	camera.current = false
	add_child(camera)

func load_and_compile(cache_path):
	var cache_packed_scene = load(cache_path)
	compile(cache_packed_scene)

func compile(cache_packed_scene):
	var cache_path = cache_packed_scene.resource_path
	if is_compiled(cache_path):
		return
	
	var cache_scene = spawn_cache(cache_packed_scene)
	cache_scene.connect("compiled", self, "_on_cache_compiled", [cache_path, cache_scene])

func spawn_cache(cache_packed_scene):
	var cache_scene = cache_packed_scene.instance()
	var active_camera = get_active_camera()
	active_camera.add_child(cache_scene)
	cache_scene.scale = Vector3.ONE * 0.001
	cache_scene.global_transform.origin = -active_camera.global_transform.basis.z * 5

	return cache_scene

func is_compiled(cache_path):
	return cache_path in _compiled_cache_paths

func _on_cache_compiled(cache_path, cache_scene):
	camera.current = false
	_compiled_cache_paths.append(cache_path)
	cache_scene.queue_free()
	emit_signal("compiled", cache_path)

func get_active_camera():
	var active_camera = get_viewport().get_camera()
	if not active_camera:
		active_camera = camera
		camera.current = true

	return active_camera
