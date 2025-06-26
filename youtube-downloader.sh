#!/bin/bash

# YOUTUBE VIDEO DOWNLOADER FOR LINUX - BY KSHITIJA RANDIVE
# DevOps-style Bash script using yt-dlp with validation and logging

set -e

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

show_banner() {
    clear
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║         YOUTUBE VIDEO DOWNLOADER - LINUX TERMINAL         ║"
    echo "║              Built with ♥ by Kshitija Randive             ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

show_banner

DOWNLOAD_DIR="$HOME/youtube-downloader/videos"
LOG_DIR="$HOME/youtube-downloader/logs"

info "Creating required folders..."
mkdir -p "$DOWNLOAD_DIR"
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/download_$(date +'%Y-%m-%d_%H-%M-%S').log"
success "Folders created. Log file will be stored at: $LOG_FILE"

info "Checking if yt-dlp is installed..."
if ! command -v yt-dlp &> /dev/null; then
    info "yt-dlp not found. Installing it now..."
    sudo curl -L https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp -o /usr/local/bin/yt-dlp
    sudo chmod a+rx /usr/local/bin/yt-dlp
    success "yt-dlp installed successfully!"
else
    success "yt-dlp is already installed."
fi

while true; do
    echo
    read -p "🔗 Enter a valid YouTube video URL: " VIDEO_URL
    if [[ $VIDEO_URL =~ ^https?://(www\.)?(youtube\.com|youtu\.be)/.+$ ]]; then
        success "Valid YouTube URL detected."
        break
    else
        error "Invalid URL. Please enter a valid YouTube link."
    fi
done

info "Downloading video..."
yt-dlp -f best -o "$DOWNLOAD_DIR/%(title)s.%(ext)s" "$VIDEO_URL" | tee "$LOG_FILE"

success "🎉 Download complete! Video saved in: $DOWNLOAD_DIR"
log "Log saved at: $LOG_FILE"
