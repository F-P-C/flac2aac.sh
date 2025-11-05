# FLAC to AAC (M4A) Batch Converter

## Overview

This script converts FLAC audio files to high-quality **320 kbps AAC (M4A)** format using `ffmpeg`. It is designed for batch processing, preserving all metadata and automatically moving original FLAC files to an archive folder upon successful conversion.

* **Converts** `.flac` files to `.m4a` (AAC, 320 kbps).
* **Preserves** all metadata and embedded album art.
* **Skips** existing `.m4a` files to prevent overwrites.
* **Moves** successfully converted original FLAC files into the **`Flac_Original_Versions`** folder.

---

## Requirements

You must have **FFmpeg** installed on your system.

On macOS (using Homebrew):
```bash
brew install ffmpeg
```
## Instructions to Run the Script

1.  Save the downloaded script file (named `flac2aac.sh`) directly into the folder that contains your FLAC music files.

2.  Open your Terminal application and use the `cd` (change directory) command to move into that specific music folder.
    ```bash
    # Example: Adjust this path to match the location of your music files
    cd ~/Music/MyFLACCollection/
    ```

3.  **Execute the Script:** Run the script by explicitly using the `bash` interpreter: 
    ```bash
    bash flac2aac.sh
    ```
*The script will immediately begin processing the FLAC files within that directory.*



---

## Conversion Specifications and Results

| Setting | Resulting Value |
| :--- | :--- |
| **Input Format** | FLAC (Lossless Audio) |
| **Output Format** | M4A (MP4) |
| **Audio Codec** | AAC (FFmpeg Native) |
| **Bitrate Target** | 320 kbps (Constant Bitrate) |
| **Metadata** | Fully Preserved |
| **Album Art** | Preserved via Stream Copy |
| **Action on Success** | Moved to `Flac_Original_Versions` |
