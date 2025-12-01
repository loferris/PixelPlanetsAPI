# Batch Planet Generation for trash-heron

This setup generates a collection of planets with custom color palettes for your Neocities site.

## Quick Start

**Static PNGs (fast - 2-3 minutes):**
```bash
cd ~/Code/PixelPlanetsAPI
./generate_planets.sh
```

This will generate **165 planets** (5 palettes × 11 planet types × 3 variations each).

**Animated GIFs (slow - 30-60 minutes):**
```bash
cd ~/Code/PixelPlanetsAPI
./generate_gifs.sh
```

This will generate **55 animated planets** (5 palettes × 11 planet types). Each GIF is a 2-second looping rotation.

## Copy to trash-heron

**After PNG generation:**
```bash
mkdir -p ~/Code/trash-heron/public/media/planets
cp ~/Code/PixelPlanetsAPI/*.png ~/Code/trash-heron/public/media/planets/
```

**After GIF generation:**
```bash
mkdir -p ~/Code/trash-heron/public/media/planets/gifs
cp ~/Code/PixelPlanetsAPI/*.gif ~/Code/trash-heron/public/media/planets/gifs/
```

## Customizing Palettes

Edit `batch_generate.gd` (for PNGs) or `batch_generate_gifs.gd` (for GIFs) and modify the `palettes` dictionary:

```gdscript
var palettes = {
	"my_palette": PoolColorArray([
		Color("#hexcode1"),
		Color("#hexcode2"),
		Color("#hexcode3"),
		# ... add 3-6 colors for best results
	]),
}
```

## Planet Types Generated

- Terran Wet / Dry
- Islands
- No atmosphere
- Gas giants (2 types)
- Ice World
- Lava World
- Asteroid
- Galaxy
- Star

## Parameters You Can Adjust

**In `batch_generate.gd` (PNGs):**
- `gui._set_pixels(200)` - Size in pixels (200 is good for web)
- `randf() * TAU` - Random rotation
- `Vector2(randf() * 0.6 + 0.2, ...)` - Light direction randomness
- `gui.set_dither(true)` - Dithering on/off

**In `batch_generate_gifs.gd` (GIFs):**
- `gif_frames = 40` - Number of frames (more = smoother but larger file)
- `gif_length = 2.0` - Duration in seconds
- `gui._set_pixels(150)` - Size (smaller = faster generation, smaller files)

## Using in React

Once copied to `public/media/planets/`, you can import them in your React components:

```jsx
import planet from '/media/planets/cosmic_purple_Star_0.png'

<img src={planet} alt="Generated planet" />
```

Or dynamically load from the directory!
