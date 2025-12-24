#!/bin/bash

set -e

# Optional: Import test library
source dev-container-features-test-lib

# Feature-specific tests
check "iptables installed" command -v iptables
check "ipset installed" command -v ipset
check "jq installed" command -v jq
check "dig installed" command -v dig
check "curl installed" command -v curl
check "aggregate installed" command -v aggregate

# The firewall script should exist and be executable
check "firewall script exists" test -f /usr/local/bin/init-firewall.sh
check "firewall script is executable" test -x /usr/local/bin/init-firewall.sh

# Report results
reportResults
