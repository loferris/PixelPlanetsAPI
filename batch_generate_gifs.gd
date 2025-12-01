extends Node

# Batch GIF generator for trash-heron
# Creates animated rotating planets with custom palettes
# GIFs will be saved to the PixelPlanetsAPI project directory

var gui
var planet_count = 0
var generation_queue = []

# GIF settings
var gif_frames = 40  # Number of frames
var gif_length = 2.0  # Length in seconds (40 frames / 2 sec = 20fps)

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

	print("Starting batch GIF generation...")
	print("Output directory: ", OS.get_executable_path().get_base_dir())
	print("GIF settings: %d frames, %.1f seconds" % [gif_frames, gif_length])

	# Build generation queue - TESTING: just first palette
	var first_palette = palettes.keys()[0]
	build_planet_queue(first_palette, palettes[first_palette])

	print("Queued ", generation_queue.size(), " animated planets to generate")
	print("This will take a while - GIFs are slower to generate!\n")

	# Start generating
	generate_next()

func build_planet_queue(palette_name, colors):
	# TESTING: Only generate 2 planets
	var planet_types = [
		"Gas giant 1",
		"Lava World"
	]

	for planet_type in planet_types:
		# Generate 1 GIF per type per palette (GIFs are bigger/slower)
		var seed_val = randi()
		var filename = "%s_%s" % [palette_name, planet_type.replace(" ", "_")]

		generation_queue.append({
			"type": planet_type,
			"seed": seed_val,
			"colors": colors,
			"filename": filename
		})

	# Only use first palette for testing
	return

func generate_next():
	if generation_queue.empty():
		print("\n=== Generation Complete ===")
		print("Generated ", planet_count, " animated planets!")
		print("Find them in: ", OS.get_executable_path().get_base_dir())
		print("\nTo use in trash-heron, copy them:")
		print("  mkdir -p ~/Code/trash-heron/public/media/planets/gifs")
		print("  cp ~/Code/PixelPlanetsAPI/*.gif ~/Code/trash-heron/public/media/planets/gifs/")
		get_tree().quit()
		return

	var planet_data = generation_queue.pop_front()
	create_planet(planet_data.type, planet_data.seed, planet_data.colors, planet_data.filename)

func create_planet(type, sd, colors, filename):
	gui.sd = sd

	var t = gui._lookup_type(type)
	gui._create_new_planet(t)
	gui._set_pixels(150)  # Slightly smaller for GIFs to keep file size down
	gui.rotate_planet(randf() * TAU)  # Random initial rotation
	gui.set_light_origin(Vector2(randf() * 0.6 + 0.2, randf() * 0.6 + 0.2))  # Random lighting
	gui.set_dither(true)

	yield(get_tree(), "idle_frame")
	gui.set_colors(colors)

	yield(get_tree(), "idle_frame")

	print("Generating GIF %d/%d: %s.gif (this may take 30-60 seconds)..." % [planet_count + 1, planet_count + generation_queue.size() + 1, filename])

	# Export animated GIF
	gui.export_gif_no_bar(gif_frames, gif_length / gif_frames)

	planet_count += 1

	# Wait longer between GIFs (they take time to generate)
	yield(get_tree().create_timer(1.0), "timeout")
	generate_next()
