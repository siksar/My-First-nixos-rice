#!/usr/bin/env bash

# Power Control Script for Gigabyte Laptop (Ryzen + RTX)
# Modes: gaming, turbo, normal, saver, auto

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        echo "Please run as root"
        exit 1
    fi
}

# Function to get power source (AC or BAT)
get_power_source() {
    # Check all power supplies for AC type and online status
    for ps in /sys/class/power_supply/*; do
        if [ -f "$ps/type" ] && [ "$(cat "$ps/type")" = "Mains" ]; then
            if [ "$(cat "$ps/online")" = "1" ]; then
                echo "AC"
                return
            fi
        fi
    done
    echo "BAT"
}

# Function to apply Gaming Mode
apply_gaming() {
    echo "Applying GAMING mode..."
    # GPU: Max Power (85W)
    nvidia-smi -pl 85
    # CPU: High Performance
    ryzenadj --stapm-limit=45000 --fast-limit=54000 --slow-limit=50000 --tctl-temp=90
    # CPU Gov
    cpupower frequency-set -g performance
    echo "GAMING mode applied."
}

# Function to apply Turbo Mode
apply_turbo() {
    echo "Applying TURBO mode..."
    # GPU: Max Power (85W) + potential clocks (requires separate tool usually, just max power for now)
    nvidia-smi -pl 85
    # CPU: Max Performance
    ryzenadj --stapm-limit=54000 --fast-limit=60000 --slow-limit=54000 --tctl-temp=95
    # CPU Gov
    cpupower frequency-set -g performance
    echo "TURBO mode applied."
}

# Function to apply Normal Mode
apply_normal() {
    echo "Applying NORMAL mode..."
    # GPU: Balanced (Define a mid-range or default, e.g., 50W or Dynamic)
    # Resetting to default limits might be different per GPU, assume 45-50W for balanced
    nvidia-smi -pl 50 
    # CPU: Balanced
    ryzenadj --stapm-limit=35000 --fast-limit=40000 --slow-limit=35000 --tctl-temp=85
    # CPU Gov
    cpupower frequency-set -g schedutil
    echo "NORMAL mode applied."
}

# Function to apply Saver Mode
apply_saver() {
    echo "Applying SAVER mode..."
    # GPU: Min Power (30W)
    nvidia-smi -pl 30
    # CPU: Power Save
    ryzenadj --stapm-limit=15000 --fast-limit=20000 --slow-limit=15000 --tctl-temp=75
    # CPU Gov
    cpupower frequency-set -g powersave
    echo "SAVER mode applied."
}

# Main logic
MODE=$1

check_root

case "$MODE" in
    "gaming")
        apply_gaming
        ;;
    "turbo")
        apply_turbo
        ;;
    "normal")
        apply_normal
        ;;
    "saver"|"tasarruf")
        apply_saver
        ;;
    "auto")
        SOURCE=$(get_power_source)
        if [ "$SOURCE" = "AC" ]; then
            apply_normal
        else
            apply_saver
        fi
        ;;
    *)
        echo "Usage: $0 {gaming|turbo|normal|saver|auto}"
        exit 1
        ;;
esac
