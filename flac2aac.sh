#!/bin/bash
set -euo pipefail

# --- Configuration ---
ENCODER="aac"
BITRATE_TARGET="320k"
ARCHIVE_FOLDER="Flac_Original_Versions"

# --- Counters ---
TOTAL_FILES=0
CONVERTED_FILES=0
SKIPPED_FILES=0
FAILED_FILES=0
MOVED_FILES=0

# --- Header ---
echo "========================================"
echo " FLAC → AAC (M4A) Conversion Script"
echo "========================================"
echo "Encoder: FFmpeg native AAC"
echo "Quality: 320 kbps CBR"
echo "Metadata: preserved (incl. artwork)"
echo "Archive: $ARCHIVE_FOLDER"
echo "========================================"
echo ""

# --- Pre-flight Checks ---

# 1. Ensure ffmpeg is available
if ! command -v ffmpeg >/dev/null 2>&1; then
  echo "ERROR: ffmpeg not installed. Install with: brew install ffmpeg"
  exit 1
fi

# 2. Ensure archive folder exists (mkdir -p creates it if it doesn't, no error if it does)
if ! mkdir -p "$ARCHIVE_FOLDER"; then
    echo "ERROR: Failed to create archive folder: $ARCHIVE_FOLDER"
    exit 1
fi

# 3. Find FLAC files using null termination
TEMP_FILE=$(mktemp)
find . -maxdepth 1 -type f -iname "*.flac" -print0 > "$TEMP_FILE"

if [ ! -s "$TEMP_FILE" ]; then
  echo "No FLAC files found in current directory."
  rm -f "$TEMP_FILE"
  # Exit 0 because 'no files found' is a successful operation
  exit 0
fi

TOTAL_FILES=$(tr -cd '\0' < "$TEMP_FILE" | wc -c | tr -d ' ')
echo "Found $TOTAL_FILES FLAC file(s) to process."
echo ""

# --- Main Conversion Loop ---
# Loop reads file list from TEMP_FILE using null delimiter (-d '')
while IFS= read -r -d '' FLAC_FILE; do
  # Determine output filename
  BASE_NAME=$(basename "$FLAC_FILE" .flac)
  AAC_FILE="./${BASE_NAME}.m4a"

  echo "----------------------------------------"
  echo "Converting: $(basename "$FLAC_FILE") → $(basename "$AAC_FILE")"

  # Skip if target exists
  if [ -f "$AAC_FILE" ]; then
    echo "STATUS: SKIPPED (Target file exists)"
    ((SKIPPED_FILES++))
    continue
  fi

  # Execute FFmpeg conversion
  # -nostdin: prevents reading the file list as interactive commands (solves previous error)
  # -map 0:a -map 0:v? -c:v copy: ensures audio and existing album art are mapped and copied
  if ffmpeg -nostdin -hide_banner -y \
      -i "$FLAC_FILE" \
      -f mp4 \
      -vn \
      -map 0:a -map 0:v? -c:v copy \
      -c:a "$ENCODER" -b:a "$BITRATE_TARGET" \
      -map_metadata 0 \
      -movflags +faststart \
      -loglevel error -stats \
      "$AAC_FILE"; then

    # Success block
    echo "STATUS: SUCCESS (Conversion complete)"
    ((CONVERTED_FILES++))
    
    # Gracefully handle the file move (Correction Applied Here)
    if mv "$FLAC_FILE" "${ARCHIVE_FOLDER}/${BASE_NAME}.flac"; then
        ((MOVED_FILES++))
    else
        echo "WARNING: Conversion OK, but FAILED to move original FLAC to archive."
    fi

  else
    # Failure block
    echo "STATUS: FAILED (Conversion error)"
    ((FAILED_FILES++))
    echo "Action: Original FLAC retained."
  fi

done < "$TEMP_FILE"

# --- Cleanup ---
rm -f "$TEMP_FILE"

# --- Final Summary ---
echo "========================================"
echo "Conversion Summary"
echo "========================================"
echo "Total found: $TOTAL_FILES"
echo "Converted:   $CONVERTED_FILES"
echo "Skipped:     $SKIPPED_FILES"
echo "Failed:      $FAILED_FILES"
echo "Moved:       $MOVED_FILES"
echo "Archive:     ./$ARCHIVE_FOLDER/"
echo "========================================"

# Determine overall exit status (Exit 1 if any conversion failed, otherwise Exit 0)
[ $FAILED_FILES -gt 0 ] && exit 1 || exit 0
