#!/bin/bash

# Batch planet generator for trash-heron
# This will generate 165 planets (5 palettes × 11 planet types × 3 variations)

echo "Starting planet generation..."
echo "This will take a few minutes..."

cd "$(dirname "$0")"

# Run Godot in headless mode with the batch generation scene
godot3 --path . BatchGenerate.tscn

echo ""
echo "Generation complete!"
echo ""
echo "To copy planets to trash-heron:"
echo "  mkdir -p ~/Code/trash-heron/public/media/planets"
echo "  cp *.png ~/Code/trash-heron/public/media/planets/"
