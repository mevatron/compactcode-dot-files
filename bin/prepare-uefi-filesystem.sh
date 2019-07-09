#!/bin/sh

set -ex

# The size of the boot partition.
BOOT_SIZE=512MiB
# The size of the swap partition.
SWAP_SIZE=4512MiB

# Partition the disk.
parted /dev/sda -- mklabel gpt
# Boot partition    (sda1)
parted /dev/sda -- mkpart ESP fat32 1MiB $BOOT_SIZE
# Primary partition (sda2)
parted /dev/sda -- mkpart primary $SWAP_SIZE 100%
# Swap partition    (sda3)
parted /dev/sda -- mkpart primary linux-swap $BOOT_SIZE $SWAP_SIZE
# Enable the boot partition.
parted /dev/sda -- set 1 boot on

# Format the boot partition.
mkfs.fat -F 32 -n boot /dev/sda1
# Format the primary partition.
mkfs.ext4 -L nixos /dev/sda2
# Format the swap partition.
mkswap -L swap /dev/sda3

# Wait for disk labels to be ready.
sleep 2

# Mount the primary & boot partitions.
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/boot  /mnt/boot

# Prepare a directory to upload or nix configuration 
mkdir -p /mnt/etc/nixos

# Activate swap.
swapon /dev/sda3