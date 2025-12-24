#!/bin/bash
set -euo pipefail

echo "Installing Devcontainer Network Firewall..."

# Function to detect package manager
detect_package_manager() {
    if command -v apt-get >/dev/null; then
        echo "apt"
    elif command -v apk >/dev/null; then
        echo "apk"
    elif command -v dnf >/dev/null; then
        echo "dnf"
    elif command -v yum >/dev/null; then
        echo "yum"
    else
        echo "unknown"
    fi
}

# Function to install packages
install_packages() {
    local pkg_manager="$1"
    shift
    local packages="$@"

    case "$pkg_manager" in
        apt)
            export DEBIAN_FRONTEND=noninteractive
            apt-get update -y
            apt-get install -y $packages
            ;;
        apk)
            apk update
            apk add $packages
            ;;
        dnf|yum)
            $pkg_manager install -y $packages
            ;;
        *)
            echo "ERROR: Unsupported package manager: $pkg_manager"
            exit 1
            ;;
    esac
}

# Map of package manager to required firewall packages
get_firewall_packages() {
    local pkg_manager="$1"

    case "$pkg_manager" in
        apt) echo "iptables ipset dnsutils jq curl aggregate" ;;
        apk) echo "iptables ipset bind-tools jq curl aggregate" ;;
        dnf|yum) echo "iptables ipset bind-utils jq curl aggregate" ;;
        *) echo "" ;;
    esac
}

# Function to install firewall packages
install_firewall_packages() {
    local pkg_manager="$1"
    local packages=$(get_firewall_packages "$pkg_manager")

    if [ -z "$packages" ]; then
        echo "ERROR: Could not determine firewall packages for this system type"
        exit 1
    fi

    echo "Installing firewall packages: $packages"
    install_packages "$pkg_manager" $packages
}

# Function to set up firewall script
setup_firewall_script() {
    local script_path="/usr/local/bin/init-firewall.sh"

    echo "Setting up firewall initialization script..."

    # Create destination directory and copy the script
    mkdir -p /usr/local/bin
    cp "$(dirname "$0")/init-firewall.sh" "$script_path"
    chmod +x "$script_path"

    echo "Firewall script installed at $script_path"
}

# Main installation flow
main() {
    echo "Detecting package manager..."
    PKG_MANAGER=$(detect_package_manager)
    echo "Detected package manager: $PKG_MANAGER"

    # Install firewall packages
    install_firewall_packages "$PKG_MANAGER"

    # Set up the firewall script
    setup_firewall_script

    cat <<EOF

Claude Firewall installed successfully!

The firewall script is installed at /usr/local/bin/init-firewall.sh

To activate the firewall, add this to your devcontainer.json:

  "postCreateCommand": "sudo /usr/local/bin/init-firewall.sh"

The firewall restricts outbound connections to only essential services
like GitHub, npm registry, and the Anthropic API.

EOF
}

# Execute main function
main
