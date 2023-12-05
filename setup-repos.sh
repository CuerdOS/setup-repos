#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Function to add repositories
add_repositories() {
    echo "Adding 'non-free' and 'contrib' repositories..."

    # Check if repositories are already present before adding
    if grep -q " non-free contrib" /etc/apt/sources.list; then
        echo "Repositories already present. No changes made."
    else
        # Add 'non-free' and 'contrib' to the end of each repository line
        sed -i '/^deb/ s/$/ non-free contrib/' /etc/apt/sources.list
        echo "Repositories added successfully."
    fi
}

# Function to remove repositories
remove_repositories() {
    echo "Removing 'non-free' and 'contrib' repositories..."

    # Remove 'non-free' and 'contrib' from each repository line
    sed -i 's/ non-free contrib//g' /etc/apt/sources.list

    echo "Repositories removed successfully."
}

# Selection menu
echo "Select an option:"
echo "1. Add 'non-free' and 'contrib' repositories"
echo "2. Remove 'non-free' and 'contrib' repositories"
read -p "Option: " option

# Process the selected option
case $option in
    1)
        add_repositories
        ;;
    2)
        remove_repositories
        ;;
    *)
        echo "Invalid option. Exiting."
        exit 1
        ;;
esac

# Update the package list
apt update

echo "Process completed successfully!"
