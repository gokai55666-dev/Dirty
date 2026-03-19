#!/bin/bash
set -e
set -o pipefail

echo "[+] Starting A6000-optimized setup..."

# --- 1️⃣ Update pip & install Python deps ---
echo "[+] Upgrading pip, setuptools, wheel..."
python3 -m pip install --upgrade pip setuptools wheel

echo "[+] Installing Python dependencies..."
python3 -m pip install zstandard torch torchvision torchaudio --upgrade
python3 -m pip install git+https://github.com/comfyanonymous/ComfyUI.git
python3 -m pip install requests numpy pillow

# --- 2️⃣ Clone ComfyUI if not exists ---
WORKDIR=~/ComfyUI
if [ ! -d "$WORKDIR" ]; then
    echo "[+] Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git "$WORKDIR"
fi

cd "$WORKDIR"

# --- 3️⃣ Optional: Add extensions (AnimateDiff, TaraLLM) ---
EXTDIR=extensions
mkdir -p "$EXTDIR"

if [ ! -d "$EXTDIR/AnimateDiffEvolved" ]; then
    echo "[+] Cloning AnimateDiffEvolved..."
    git clone https://github.com/animate-diff/AnimateDiffEvolved.git "$EXTDIR/AnimateDiffEvolved"
fi

if [ ! -d "$EXTDIR/TaraLLM" ]; then
    echo "[+] Cloning TaraLLM..."
    git clone https://github.com/GoonsAI/TaraLLM.git "$EXTDIR/TaraLLM"
fi

# --- 4️⃣ Create model & output dirs ---
mkdir -p models outputs

# --- 5️⃣ Start ComfyUI ---
echo "[+] Launching ComfyUI on port 8188..."
python3 main.py --listen --port 8188 &

# --- 6️⃣ Optional: Start Ollama NSFW LLM ---
# Uncomment if Ollama already installed
# echo "[+] Launching Ollama Goonsai model..."
# ollama serve goonsai &

echo "[+] Setup complete! Access UI at http://<your-ip>:8188"
