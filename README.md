## FLAC to AAC (M4A) Batch Converter

This script converts FLAC audio files to high-quality **320 kbps AAC (M4A)** format using `ffmpeg`. It is designed for batch processing, preserving all metadata and automatically moving original FLAC files to an archive folder upon successful conversion.
---
* **Conversion:** Converts `.flac` files to `.m4a` (AAC, 320 kbps).
* **Quality:** Preserves all metadata and embedded album art.
* **Safety:** Skips existing `.m4a` files to prevent overwrites.
* **Archive:** Moves successfully converted original FLAC files into the **`Flac_Original_Versions`** folder.
---
## Requirements

You must have **FFmpeg** installed on your system.

On macOS (using Homebrew):
```bash
brew install ffmpeg
```
## How to Run
Save the Script: Save the code as `flac2aac.sh.`

Permissions: Make the script executable:
```bash
chmod +x flac2aac.sh`
```

Execute: Navigate to the directory containing your FLAC files and run:
```bash
./flac2aac.sh
```
The script will process all .flac files in the current directory and provide a summary of the results.

| Setting | Resulting Value |
| :--- | :--- |
| **Input Format** | FLAC (Lossless Audio) |
| **Output Format** | M4A (MP4) |
| **Audio Codec** | AAC (FFmpeg Native) |
| **Bitrate Target** | 320 kbps (Constant Bitrate) |
| **Metadata** | Fully Preserved |
| **Album Art** | Preserved via Stream Copy |
| **Action on Success** | Moved to `Flac_Original_Versions` |
