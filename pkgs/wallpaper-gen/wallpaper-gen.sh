#!/usr/bin/env bash
# Generate a wallpaper using a SVG logo.
# Usage: wallpaper-gen <svg_path> <bg_color> <fg_color> <width>x<height> <output_file>
# Example: wallpaper-gen logo.svg '#000000' '#ffffff' 1920x1080 wallpaper.png
#   
# Parameters:
#   <svg_path>          Path to SVG file
#   <bg_color>          Background color in hex format
#   <fg_color>          Foreground color in hex format
#   <width>x<height>    Output dimensions in pixels
#   <output_file>       Output file

set -euo pipefail

SVG_PATH="${1}"
BG_COLOR="${2}"
FG_COLOR="${3}"
DIMENSIONS="${4}"
OUTPUT_FILE="${5}"

# Create temporary directory
TEMP_DIR=$(mktemp -d)
TEMP_SVG="${TEMP_DIR}/temp.svg"
TEMP_PNG="${TEMP_DIR}/temp.png"

# Make a copy of the SVG and replace colors
cp "${SVG_PATH}" "${TEMP_SVG}"

# Use sed to replace colors in the SVG
sed -i -E "s/fill=\"[^\"]*\"/fill=\"$FG_COLOR\"/g" "${TEMP_SVG}"
sed -i -E "s/stroke=\"[^\"]*\"/stroke=\"$FG_COLOR\"/g" "${TEMP_SVG}"

# Extract height to calculate SVG_SIZE
HEIGHT=$(echo "${DIMENSIONS}" | cut -d'x' -f2)
# Convert SVG to PNG with Inkscape
SVG_SIZE=$(( HEIGHT * 5 / 10 ))
inkscape --export-filename="${TEMP_PNG}" "${TEMP_SVG}" --export-width="${SVG_SIZE}" --export-height="${SVG_SIZE}" 2>/dev/null

# Create background with the specified color
magick -size "${DIMENSIONS}" canvas:"${BG_COLOR}" "${OUTPUT_FILE}"

# Calculate the size for the SVG (70% of the smallest dimension)

# Resize the SVG PNG while maintaining aspect ratio
magick "${TEMP_PNG}" -background none -resize "${SVG_SIZE}x${SVG_SIZE}" "${TEMP_PNG}"

# Composite the SVG on top of the background, centered
magick "${OUTPUT_FILE}" "${TEMP_PNG}" -gravity center -composite "${OUTPUT_FILE}"

# Clean up temporary files
rm -rf "${TEMP_DIR}"

echo "Wallpaper created successfully: ${OUTPUT_FILE}"