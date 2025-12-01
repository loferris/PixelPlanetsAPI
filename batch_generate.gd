extends Node

# Batch planet generator for trash-heron
# Creates a collection of planets with custom palettes
# Images will be saved to the PixelPlanetsAPI project directory

var gui
var planet_count = 0
var current_palette = ""
var current_filename = ""
var generation_queue = []

# Define your custom color palettes here
var palettes = {
	"cosmic_purple": PoolColorArray([
		Color("#1a0033"), Color("#2d0052"), Color("#4a0080"),
		Color("#6600cc"), Color("#8533ff"), Color("#a366ff")
	]),
	"ocean_blue": PoolColorArray([
		Color("#001a33"), Color("#003366"), Color("#005599"),
		Color("#0077cc"), Color("#33aaff"), Color("#66ccff")
	]),
	"sunset": PoolColorArray([
		Color("#1a0a00"), Color("#331400"), Color("#4d2200"),
		Color("#ff6600"), Color("#ff9933"), Color("#ffcc66")
	]),
	"forest": PoolColorArray([
		Color("#0d1a0d"), Color("#1a331a"), Color("#2d5c2d"),
		Color("#408040"), Color("#5ca65c"), Color("#80cc80")
	]),
	"lava": PoolColorArray([
		Color("#1a0000"), Color("#330000"), Color("#660000"),
		Color("#cc0000"), Color("#ff3300"), Color("#ff6600")
	])
}

func _ready():
	gui = get_parent().get_node("GUI")
	yield(get_tree(), "idle_frame")

	print("Starting batch planet generation...")
	print("Output directory: ", OS.get_executable_path().get_base_dir())

	# Build generation queue
	for palette_name in palettes.keys():
		build_planet_queue(palette_name, palettes[palette_name])

	print("Queued ", generation_queue.size(), " planets to generate")

	# Start generating
	generate_next()

func build_planet_queue(palette_name, colors):
	var planet_types = [
		"Terran Wet", "Terran Dry", "Island", "No atmosphere",
		"Gas giant 1", "Gas giant 2", "Ice World", "Lava World",
		"Asteroid", "Galaxy", "Star"
	]

	for planet_type in planet_types:
		# Generate 3 variations per type per palette
		for i in range(3):
			var seed_val = randi()
			var filename = "%s_%s_%d" % [palette_name, planet_type.replace(" ", "_"), i]

			generation_queue.append({
				"type": planet_type,
				"seed": seed_val,
				"colors": colors,
				"filename": filename
			})

func generate_next():
	if generation_queue.empty():
		print("\n=== Generation Complete ===")
		print("Generated ", planet_count, " planets!")
		print("Find them in: ", OS.get_executable_path().get_base_dir())
		print("\nTo use in trash-heron, copy them:")
		print("  cp ~/Code/PixelPlanetsAPI/*.png ~/Code/trash-heron/public/media/planets/")
		get_tree().quit()
		return

	var planet_data = generation_queue.pop_front()
	current_filename = planet_data.filename
	create_planet(planet_data.type, planet_data.seed, planet_data.colors)

func create_planet(type, sd, colors):
	gui.sd = sd
	current_filename = str(sd)  # Use seed as filename (GUI.gd will use this)

	var t = gui._lookup_type(type)
	gui._create_new_planet(t)
	gui._set_pixels(200)  # Good size for web
	gui.rotate_planet(randf() * TAU)  # Random rotation
	gui.set_light_origin(Vector2(randf() * 0.6 + 0.2, randf() * 0.6 + 0.2))  # Random lighting
	gui.set_dither(true)

	yield(get_tree(), "idle_frame")
	gui.set_colors(colors)

	yield(get_tree(), "idle_frame")

	# Use the API's export function
	gui._export_img()

	planet_count += 1
	print("Generated %d/%d: %s.png" % [planet_count, planet_count + generation_queue.size(), sd])

	# Wait a bit then generate next
	yield(get_tree().create_timer(0.1), "timeout")
	generate_next()
