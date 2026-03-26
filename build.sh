#!/usr/bin/env bash
set -e

# File paths

SRC_FILE="./src/Main.java"
OUT_DIR="./out"

# Create output directory

mkdir -p "$OUT_DIR"

echo "Compiling Java source..."
javac -d "$OUT_DIR" "$SRC_FILE"

echo "Running program..."

# Extract class name (assumes class name matches file name)

CLASS_NAME="Main"

java -cp "$OUT_DIR" "$CLASS_NAME"
echo "Done."