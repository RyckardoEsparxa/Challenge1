#!/bin/bash

# number of arguments
if [ "$#" -ne 7 ]; then
    echo "Usage: $0 <VM_Name> <OS_Type> <CPUs> <RAM_GB> <VRAM_MB> <Disk_Size_MB> <SATA_Controller_Name>"
    exit 1
fi

# Get arguments
VM_NAME="$1"
OS_TYPE="$2"
CPUS="$3"
RAM=$(($4 * 1024))  # Convert GB to MB
VRAM="$5"
DISK_SIZE="$6"
SATA_CONTROLLER="$7"
IDE_CONTROLLER="IDE_Controller"

# Step 1: Create the virtual machine
if VBoxManage createvm --name "$VM_NAME" --ostype "$OS_TYPE" --register; then
    echo "Virtual machine '$VM_NAME' created successfully."
else
    echo "Error creating virtual machine: $VM_NAME"
    exit 1
fi

# Step 2: Modify VM settings (CPUs, RAM, VRAM)
if VBoxManage modifyvm "$VM_NAME" --cpus "$CPUS" --memory "$RAM" --vram "$VRAM"; then
    echo "VM settings modified successfully."
else
    echo "Error modifying VM settings: $VM_NAME"
    exit 1
fi

# Step 3: Create a virtual hard disk
if VBoxManage createmedium disk --filename "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi" --size "$DISK_SIZE" --format VDI; then
    echo "Virtual hard disk created successfully."
else
    echo "Error creating virtual hard disk: $VM_NAME"
    exit 1
fi

# Step 4: Create and configure SATA controller, and attach the virtual disk
if VBoxManage storagectl "$VM_NAME" --name "$SATA_CONTROLLER" --add sata --controller IntelAhci; then
    echo "SATA controller created successfully."
else
    echo "Error creating SATA controller: $VM_NAME"
    exit 1
fi

if VBoxManage storageattach "$VM_NAME" --storagectl "$SATA_CONTROLLER" --port 0 --device 0 --type hdd --medium "$HOME/VirtualBox VMs/$VM_NAME/$VM_NAME.vdi"; then
    echo "Virtual hard disk attached to SATA controller successfully."
else
    echo "Error attaching virtual hard disk to SATA controller: $VM_NAME"
    exit 1
fi

# Step 5: Create and configure IDE controller
if VBoxManage storagectl "$VM_NAME" --name "$IDE_CONTROLLER" --add ide --controller PIIX4; then
    echo "IDE controller created successfully."
else
    echo "Error creating IDE controller: $VM_NAME"
    exit 1
fi

# Attach an empty DVD drive to the IDE controller
if VBoxManage storageattach "$VM_NAME" --storagectl "$IDE_CONTROLLER" --port 0 --device 0 --type dvddrive --medium emptydrive; then
    echo "DVD drive attached to IDE controller successfully."
else
    echo "Error attaching DVD drive to IDE controller: $VM_NAME"
    exit 1
fi

# Step 6: Print configuration details
echo "Virtual Machine '$VM_NAME' created with the following configuration:"
VBoxManage showvminfo "$VM_NAME" | grep -e "Name:" -e "Memory size:" -e "VRAM size:" -e "Number of CPUs:" -e "Guest OS:" -e "SATA" -e "Hard disk:" -e "DVD Drive:" -e "IDE"
