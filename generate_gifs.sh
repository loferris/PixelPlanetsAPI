#!/bin/bash

# Batch GIF generator for trash-heron
# This will generate 55 animated planets (5 palettes × 11 planet types)
# WARNING: This takes MUCH longer than PNG generation (30-60 min)

echo "Starting animated planet generation..."
echo "This will take 30-60 minutes - GIFs are slow to generate!"
echo "Each planet is a 2-second looping animation."
echo ""

cd "$(dirname "$0")"

# Run Godot in headless mode with the GIF batch generation scene
godot3 --path . BatchGenerateGifs.tscn

echo ""
echo "Generation complete!"
echo ""
echo "To copy animated planets to trash-heron:"
echo "  mkdir -p ~/Code/trash-heron/public/media/planets/gifs"
echo "  cp *.gif ~/Code/trash-heron/public/media/planets/gifs/"
