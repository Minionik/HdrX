#!/bin/bash

# ================================
# Security Headers Checker
# ================================

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m' # No Color

echo "====================================="
echo "   Security Headers Enumeration Tool "
echo "====================================="

# Input target
read -p "Enter target URL (e.g., https://example.com): " TARGET

# Input custom headers (optional)
echo ""
echo "Paste custom headers (if any)."
echo "Example: Cookie: JSESSIONID=abc123"
echo "You can paste multiple headers."
echo "Press ENTER on empty line to continue."
echo ""

CUSTOM_HEADERS=()

while true; do
    read -p "> " line
    [[ -z "$line" ]] && break
    CUSTOM_HEADERS+=("-H" "$line")
done

echo ""
echo "[*] Fetching headers from $TARGET ..."
echo ""

# Fetch headers
RESPONSE_HEADERS=$(curl -s -D - -o /dev/null "$TARGET" "${CUSTOM_HEADERS[@]}")

# Define ALL important security headers
SEC_HEADERS=(
    "Strict-Transport-Security"
    "Content-Security-Policy"
    "X-Frame-Options"
    "X-Content-Type-Options"
    "Referrer-Policy"
    "Permissions-Policy"
    "X-XSS-Protection"
    "Expect-CT"
    "Cache-Control"
    "Pragma"
    "Access-Control-Allow-Origin"
    "Access-Control-Allow-Credentials"
    "Access-Control-Allow-Methods"
    "Access-Control-Allow-Headers"
    "Cross-Origin-Embedder-Policy"
    "Cross-Origin-Opener-Policy"
    "Cross-Origin-Resource-Policy"
    "Timing-Allow-Origin"
    "X-Permitted-Cross-Domain-Policies"
    "Clear-Site-Data"
    "Set-Cookie"
    "Server"
    "X-Powered-By"
)

echo "====================================="
echo "        Security Header Results      "
echo "====================================="

# Check each header
for header in "${SEC_HEADERS[@]}"; do
    if echo "$RESPONSE_HEADERS" | grep -iq "^$header:"; then
        echo -e "${GREEN}[+] $header: PRESENT${NC}"
    else
        echo -e "${RED}[-] $header: MISSING${NC}"
    fi
done

echo "====================================="
echo "            Raw Headers              "
echo "====================================="
echo "$RESPONSE_HEADERS"
