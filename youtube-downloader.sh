#!/bin/bash

# 🎬 YOUTUBE VIDEO DOWNLOADER FOR LINUX
# 🔧 Created by Kshitija Randive | DevOps • GCP • AWS • Linux

set -e

# ---------------- Colors & Logging ----------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log()     { echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1"; }
info()    { echo -e "${BLUE}[INFO]${NC} $1"; }
success() { echo -e "${PURPLE}[SUCCESS]${NC} $1"; }
error()   { echo -e "${RED}[ERROR]${NC} $1"; }

# ---------------- Banner ----------------
show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         YOUTUBE VIDEO DOWNLOADER - LINUX TERMINAL         ║"
    echo "║              Built with ♥ by Kshitija Randive             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

# ---------------- Execution ----------------
show_banner

DOWNLOAD_DIR="$HOME/youtube-downloader/videos"
LOG_DIR="$HOME/youtube-downloader/logs"

info "Creating folders if not present..."
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/download_$(date +'%Y-%m-%d_%H-%M-%S').log"
success "Download log will be saved at: $LOG_FILE"

# ---------------- yt-dlp Check & Update ----------------
info "Checking yt-dlp installation..."
if ! command -v yt-dlp &> /dev/null; then
    info "yt-dlp not found. Installing..."
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
    success "yt-dlp installed."
else
    info "yt-dlp already installed. Checking for updates..."
    sudo yt-dlp -U || true
fi

# ---------------- Get Video URL ----------------
while true; do
    echo
    read -p "🔗 Enter a valid YouTube video URL: " VIDEO_URL
    if [[ $VIDEO_URL =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/.+$ ]]; then
        success "Valid YouTube URL."
        break
    else
        error "Invalid URL. Please try again."
    fi
done

# ---------------- Download Section ----------------
echo
read -p "🎞️  Preferred resolution (e.g., 720p, 1080p or leave blank for best): " RESOLUTION

FORMAT="bestvideo[height<=?${RESOLUTION}]+bestaudio/best"
if [ -z "$RESOLUTION" ]; then
    FORMAT="bestvideo+bestaudio/best"
fi

info "Downloading video..."
{
    yt-dlp --no-playlist -f "$FORMAT" -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$VIDEO_URL"
} 2>&1 | tee "$LOG_FILE" || {
    error "Download failed. Trying fallback method..."
    yt-dlp --force-generic-extractor -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$VIDEO_URL" | tee -a "$LOG_FILE"
}

success "🎉 Download complete!"
log "Video saved in: $DOWNLOAD_DIR"
log "Log saved at: $LOG_FILE"

