#!/bin/bash

# written by Claude Sonnet 4

# Configuration
FILE_TYPES=("pdf" "pxd")
DIRECTORIES=("orig-media")

# Function to zip a single file with -j (junk paths)
zip_file() {
    local file="$1"
    local output="${file}.zip"
    
    echo "Zipping $file -> $output"
    zip -j "$output" "$file"
}

# Function to zip directories preserving structure
zip_directories() {
    for dir in "${DIRECTORIES[@]}"; do
        if [ -d "$dir" ]; then
            echo "Zipping $dir directory -> ${dir}.zip"
            zip -r "${dir}.zip" "$dir/"
        else
            echo "Warning: $dir directory not found"
        fi
    done
}

# Show usage
show_usage() {
    echo "Usage: $0 [--all | -n filename]"
    echo "  --all    : Zip all file types [ .${FILE_TYPES[*]} ] files, plus directories: [ ${DIRECTORIES[*]} ]"
    echo "  -n FILE  : Zip specified file"
    echo ""
    echo "Configure file types and directories at the top of ${0}"
    exit 1
}

# Main logic
case "$1" in
    --all)
        # Zip files by type
        for type in "${FILE_TYPES[@]}"; do
            for file in *."$type"; do
                [ -f "$file" ] && zip_file "$file"
            done
        done
        
        # Zip directories
        zip_directories
        ;;
    -n)
        if [ -z "$2" ]; then
            echo "Error: -n requires a filename"
            show_usage
        fi
        
        if [ -f "$2" ]; then
            zip_file "$2"
        else
            echo "Error: File '$2' not found"
            exit 1
        fi
        ;;
    *)
        show_usage
        ;;
esac
